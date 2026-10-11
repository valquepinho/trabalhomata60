-- ==============================================================================
-- CONSULTAS INTERMEDIÁRIAS (1 a 30)
-- Requisito: Mínimo 3 tabelas + 2 funções (JOIN, GROUP BY, WINDOW, COUNT)
-- ==============================================================================

-- 01. Total de submissões por evento (RF42 - i) | Funções: JOIN, GROUP BY, COUNT
SELECT ev.nm_evento, COUNT(sub.cp_id_submissao) AS total_submissoes
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
GROUP BY ev.nm_evento;

-- 02. Quantidade de membros no comitê por trilha (RF42 - viii) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(com.cp_id_comite) AS total_membros
FROM tbl_trilha tr
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
INNER JOIN tbl_comite com ON tr.cp_id_trilha = com.ce_trilha
GROUP BY tr.nm_trilha;

-- 03. Autores distintos por instituição (RF42 - xv) | Funções: JOIN, GROUP BY, COUNT
SELECT inst.nm_instituicao, COUNT(DISTINCT esc.ce_pessoa) AS total_autores
FROM tbl_instituicao inst
INNER JOIN tbl_vinculo_institucional vin ON inst.cp_id_instituicao = vin.ce_instituicao
INNER JOIN tbl_escreve esc ON vin.ce_pessoa = esc.ce_pessoa
GROUP BY inst.nm_instituicao;

-- 04. Número de submissões por tópico (RF42 - ii) | Funções: JOIN, GROUP BY, COUNT
SELECT top.nm_topico, COUNT(ab.ce_submissao) AS total_submissoes
FROM tbl_topico top
INNER JOIN tbl_trilha tr ON top.ce_trilha = tr.cp_id_trilha
INNER JOIN tbl_aborda ab ON top.cp_id_topico = ab.ce_topico
GROUP BY top.nm_topico;

-- 05. Revisões concluídas por revisor (RF42 - iii) | Funções: JOIN, GROUP BY, COUNT
SELECT p.nm_pessoa, COUNT(rev.cp_id_revisao) AS revisoes_concluidas
FROM tbl_pessoa p
INNER JOIN tbl_comite com ON p.cp_id_pessoa = com.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON com.cp_id_comite = atr.ce_revisor
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
WHERE rev.status_revisao = 'SUBMETIDA'
GROUP BY p.nm_pessoa;

-- 06. Instituições com mais trabalhos aceitos (RF42 - xii) | Funções: JOIN, GROUP BY, COUNT
SELECT i.nm_instituicao, COUNT(s.cp_id_submissao) AS trabalhos_aceitos
FROM tbl_submissao s
INNER JOIN tbl_escreve e ON s.cp_id_submissao = e.ce_submissao
INNER JOIN tbl_vinculo_institucional vi ON e.ce_pessoa = vi.ce_pessoa
INNER JOIN tbl_instituicao i ON vi.ce_instituicao = i.cp_id_instituicao
WHERE s.status_submissao = 'ACEITA'
GROUP BY i.nm_instituicao;

-- 07. Quantidade de versões submetidas por artigo (RF11) | Funções: JOIN, GROUP BY, COUNT
SELECT s.titulo_submissao, COUNT(v.cp_id_versao) AS total_versoes
FROM tbl_submissao s
INNER JOIN tbl_trilha t ON s.ce_trilha = t.cp_id_trilha
INNER JOIN tbl_versao_submissao v ON s.cp_id_submissao = v.ce_submissao
GROUP BY s.titulo_submissao;

-- 08. Submissões por idioma em evento (RF6) | Funções: JOIN, GROUP BY, COUNT
SELECT ev.nm_evento, sub.idioma_submissao, COUNT(sub.cp_id_submissao) AS qtd
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
GROUP BY ev.nm_evento, sub.idioma_submissao;

-- 09. Conflitos de coautoria institucional potenciais (RF18) | Funções: JOIN, GROUP BY, COUNT
SELECT i.nm_instituicao, COUNT(atr.cp_id_atribuicao) AS potenciais_conflitos
FROM tbl_atribuicao_revisao atr
INNER JOIN tbl_comite com ON atr.ce_revisor = com.cp_id_comite
INNER JOIN tbl_vinculo_institucional vi_rev ON com.ce_pessoa = vi_rev.ce_pessoa
INNER JOIN tbl_instituicao i ON vi_rev.ce_instituicao = i.cp_id_instituicao
INNER JOIN tbl_escreve esc ON atr.ce_submissao = esc.ce_submissao
INNER JOIN tbl_vinculo_institucional vi_aut ON esc.ce_pessoa = vi_aut.ce_pessoa
WHERE vi_rev.ce_instituicao = vi_aut.ce_instituicao
GROUP BY i.nm_instituicao;

-- 10. Total de revisões por tipo de anonimato (RF39) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.tp_anonimato, COUNT(rev.cp_id_revisao) AS avaliacoes
FROM tbl_trilha tr
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
INNER JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
GROUP BY tr.tp_anonimato;

-- 11. Quantidade de revisões recusadas por pessoa (RF42 - vii) | Funções: JOIN, GROUP BY, COUNT
SELECT p.nm_pessoa, COUNT(atr.cp_id_atribuicao) as recusas
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON c.cp_id_comite = atr.ce_revisor
WHERE atr.status_atribuicao = 'RECUSADA'
GROUP BY p.nm_pessoa;

-- 12. Tópicos científicos definidos por trilha (RF9) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(top.cp_id_topico) as qtd_topicos
FROM tbl_trilha tr
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
INNER JOIN tbl_topico top ON tr.cp_id_trilha = top.ce_trilha
GROUP BY tr.nm_trilha;

-- 13. Submissões totais por status na plataforma (RF42 - x) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, s.status_submissao, COUNT(s.cp_id_submissao) as qtd
FROM tbl_trilha tr
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
GROUP BY tr.nm_trilha, s.status_submissao;

-- 14. Autores adicionados por outros usuários (RF8) | Funções: JOIN, GROUP BY, COUNT
SELECT p_adicionador.nm_pessoa as adicionou, COUNT(esc.ce_pessoa) as qtd_autores_inseridos
FROM tbl_escreve esc
INNER JOIN tbl_submissao s ON esc.ce_submissao = s.cp_id_submissao
INNER JOIN tbl_pessoa p_adicionador ON esc.ce_adicionado_por = p_adicionador.cp_id_pessoa
GROUP BY p_adicionador.nm_pessoa;

-- 15. Instituições por país de origem (RF5) | Funções: JOIN, GROUP BY, COUNT
SELECT p.pais_pessoa, COUNT(i.cp_id_instituicao) as qtd_instituicoes
FROM tbl_pessoa p
INNER JOIN tbl_vinculo_institucional vi ON p.cp_id_pessoa = vi.ce_pessoa
INNER JOIN tbl_instituicao i ON vi.ce_instituicao = i.cp_id_instituicao
GROUP BY p.pais_pessoa;

-- 16. Média de revisores requeridos por edição (RF13) | Funções: JOIN, GROUP BY, COUNT
SELECT ed.ano_edicao, COUNT(tr.cp_id_trilha) as qtd_trilhas, SUM(tr.nr_revisores_desejado) as total_revisores_necessarios
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
GROUP BY ed.ano_edicao;

-- 17. Contagem de revisões concluídas com recomendação de aceite (RF26) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(rev.cp_id_revisao) as recomendacoes_positivas
FROM tbl_trilha tr
INNER JOIN tbl_atribuicao_revisao atr ON tr.cp_id_trilha = atr.ce_trilha
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
WHERE rev.recomendacao = 'ACEITAR'
GROUP BY tr.nm_trilha;

-- 18. Inscritos como membros de comitê por edição de evento (RF14) | Funções: JOIN, GROUP BY, COUNT
SELECT ev.nm_evento, ed.ano_edicao, COUNT(c.cp_id_comite) as membros_inscritos
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_comite c ON tr.cp_id_trilha = c.ce_trilha
GROUP BY ev.nm_evento, ed.ano_edicao;

-- 19. Vínculos institucionais encerrados (RF5) | Funções: JOIN, GROUP BY, COUNT
SELECT p.nm_pessoa, COUNT(vi.cp_id_vinculo) as vinculos_encerrados
FROM tbl_pessoa p
INNER JOIN tbl_vinculo_institucional vi ON p.cp_id_pessoa = vi.ce_pessoa
INNER JOIN tbl_instituicao i ON vi.ce_instituicao = i.cp_id_instituicao
WHERE vi.dt_fim IS NOT NULL
GROUP BY p.nm_pessoa;

-- 20. Pessoas com ORCID agrupadas por instituição (RF3) | Funções: JOIN, GROUP BY, COUNT
SELECT i.nm_instituicao, COUNT(p.cp_id_pessoa) as pesquisadores_com_orcid
FROM tbl_instituicao i
INNER JOIN tbl_vinculo_institucional vi ON i.cp_id_instituicao = vi.ce_instituicao
INNER JOIN tbl_pessoa p ON vi.ce_pessoa = p.cp_id_pessoa
WHERE p.cd_orcid IS NOT NULL
GROUP BY i.nm_instituicao;

-- 21. Atribuições de revisão importadas automaticamente (RF16) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(atr.cp_id_atribuicao) as originadas_automaticamente
FROM tbl_trilha tr
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
INNER JOIN tbl_atribuicao_revisao atr ON s.cp_id_submissao = atr.ce_submissao
WHERE atr.tp_origem_atribuicao = 'AUTOMATICA'
GROUP BY tr.nm_trilha;

-- 22. Pessoas com papel de Coordenador de Trilha (RF4) | Funções: JOIN, GROUP BY, COUNT
SELECT p.nm_pessoa, COUNT(c.cp_id_comite) as atuacoes_coordenador
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_trilha tr ON c.ce_trilha = tr.cp_id_trilha
WHERE c.funcao = 'COORDENADOR_TRILHA'
GROUP BY p.nm_pessoa;

-- 23. Versões definidas como Documento Adicional (RF36) | Funções: JOIN, GROUP BY, COUNT
SELECT s.titulo_submissao, COUNT(v.cp_id_versao) as docs_adicionais
FROM tbl_submissao s
INNER JOIN tbl_trilha tr ON s.ce_trilha = tr.cp_id_trilha
INNER JOIN tbl_versao_submissao v ON s.cp_id_submissao = v.ce_submissao
WHERE v.tp_versao = 'DOCUMENTO_ADICIONAL'
GROUP BY s.titulo_submissao;

-- 24. Autores principais (Responsáveis) por evento (RF7) | Funções: JOIN, GROUP BY, COUNT
SELECT ev.nm_evento, COUNT(esc.ce_pessoa) as autores_principais
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
INNER JOIN tbl_escreve esc ON s.cp_id_submissao = esc.ce_submissao
WHERE esc.in_responsavel = TRUE
GROUP BY ev.nm_evento;

-- 25. Submissões sem notas na revisão (RF25) | Funções: JOIN, GROUP BY, COUNT
SELECT s.titulo_submissao, COUNT(rev.cp_id_revisao) as revisoes_sem_nota
FROM tbl_submissao s
INNER JOIN tbl_atribuicao_revisao atr ON s.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
WHERE rev.nota_geral IS NULL
GROUP BY s.titulo_submissao;

-- 26. Distribuição de níveis de expertise (RF10) | Funções: JOIN, GROUP BY, COUNT
SELECT top.nm_topico, ti.nivel_expertise, COUNT(ti.ce_pessoa) as especialistas
FROM tbl_topico top
INNER JOIN tbl_trilha tr ON top.ce_trilha = tr.cp_id_trilha
INNER JOIN tabela_imp_tem_interesse ti ON top.cp_id_topico = ti.ce_topico
GROUP BY top.nm_topico, ti.nivel_expertise;

-- 27. Trabalhos submetidos no prazo final (RF37) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(s.cp_id_submissao) as submissoes_ultima_hora
FROM tbl_trilha tr
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
WHERE CAST(s.dt_registro AS DATE) = tr.dt_fim_submissoes
GROUP BY tr.nm_trilha;

-- 28. Comitês inativos (RF14) | Funções: JOIN, GROUP BY, COUNT
SELECT p.nm_pessoa, COUNT(c.cp_id_comite) as participacoes_inativas
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_trilha tr ON c.ce_trilha = tr.cp_id_trilha
WHERE c.situacao = 'INATIVO'
GROUP BY p.nm_pessoa;

-- 29. Submissões brasileiras por trilha (RF5) | Funções: JOIN, GROUP BY, COUNT
SELECT tr.nm_trilha, COUNT(DISTINCT s.cp_id_submissao) as submissoes_br
FROM tbl_trilha tr
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
INNER JOIN tbl_escreve e ON s.cp_id_submissao = e.ce_submissao
INNER JOIN tbl_pessoa p ON e.ce_pessoa = p.cp_id_pessoa
WHERE p.pais_pessoa = 'BR'
GROUP BY tr.nm_trilha;

-- 30. Quantidade de edições por evento (RF1) | Funções: JOIN, GROUP BY, COUNT
SELECT ev.nm_evento, COUNT(ed.cp_id_edicao) as total_edicoes
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
GROUP BY ev.nm_evento;

-- ==============================================================================
-- CONSULTAS AVANÇADAS (31 a 50)
-- Requisito: Mínimo 3 tabelas + 3 funções (SUB-CONSULTAS, JOIN, GROUP BY, WINDOW, COUNT)
-- ==============================================================================

-- 31. Revisores sobrecarregados (RF42 - iv) | Funções: JOIN, GROUP BY, COUNT, SUB-CONSULTA
SELECT p.nm_pessoa, COUNT(atr.cp_id_atribuicao) AS carga
FROM tbl_pessoa p
INNER JOIN tbl_comite com ON p.cp_id_pessoa = com.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON com.cp_id_comite = atr.ce_revisor
GROUP BY p.nm_pessoa
HAVING COUNT(atr.cp_id_atribuicao) > (
    SELECT AVG(carga.q) FROM (
        SELECT COUNT(a2.cp_id_atribuicao) AS q FROM tbl_atribuicao_revisao a2 GROUP BY a2.ce_revisor
    ) AS carga
);

-- 32. Ranking submissões por nota (RF42 - xi) | Funções: JOIN, GROUP BY, WINDOW
SELECT tr.nm_trilha, sub.titulo_submissao, AVG(rev.nota_geral) AS media,
       RANK() OVER (PARTITION BY tr.cp_id_trilha ORDER BY AVG(rev.nota_geral) DESC) AS ranking
FROM tbl_trilha tr
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
INNER JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
GROUP BY tr.cp_id_trilha, tr.nm_trilha, sub.cp_id_submissao, sub.titulo_submissao;

-- 33. Submissões com falta de revisores (RF42 - v) | Funções: JOIN, GROUP BY, COUNT, SUB-CONSULTA
SELECT tr.nm_trilha, sub.titulo_submissao, COUNT(atr.cp_id_atribuicao) AS alocados, tr.nr_revisores_desejado
FROM tbl_trilha tr
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
LEFT JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao AND atr.status_atribuicao IN ('PENDENTE', 'ACEITA')
GROUP BY tr.nm_trilha, sub.titulo_submissao, tr.nr_revisores_desejado
HAVING COUNT(atr.cp_id_atribuicao) < tr.nr_revisores_desejado;

-- 34. Pessoas autoras e revisoras na mesma edição (RF4) | Funções: JOIN, GROUP BY, SUB-CONSULTA
SELECT p.nm_pessoa, ed.ano_edicao
FROM tbl_pessoa p
INNER JOIN tbl_escreve esc ON p.cp_id_pessoa = esc.ce_pessoa
INNER JOIN tbl_submissao sub ON esc.ce_submissao = sub.cp_id_submissao
INNER JOIN tbl_trilha tr ON sub.ce_trilha = tr.cp_id_trilha
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
WHERE p.cp_id_pessoa IN (
    SELECT c.ce_pessoa FROM tbl_comite c 
    INNER JOIN tbl_trilha t2 ON c.ce_trilha = t2.cp_id_trilha WHERE t2.ce_edicao = ed.cp_id_edicao
)
GROUP BY p.nm_pessoa, ed.ano_edicao;

-- 35. Divergência alta nas notas (RF42 - x) | Funções: JOIN, GROUP BY, COUNT
SELECT sub.titulo_submissao, MAX(rev.nota_geral) AS mx, MIN(rev.nota_geral) AS mn, (MAX(rev.nota_geral) - MIN(rev.nota_geral)) AS divergencia
FROM tbl_submissao sub
INNER JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
WHERE rev.status_revisao = 'SUBMETIDA'
GROUP BY sub.titulo_submissao
HAVING COUNT(rev.cp_id_revisao) >= 2 AND (MAX(rev.nota_geral) - MIN(rev.nota_geral)) >= 3;

-- 36. Distribuição % de Recomendações (RF42 - ix) | Funções: JOIN, GROUP BY, COUNT, WINDOW
SELECT tr.nm_trilha, rev.recomendacao, COUNT(rev.cp_id_revisao) AS total,
       ROUND((COUNT(rev.cp_id_revisao) * 100.0) / SUM(COUNT(rev.cp_id_revisao)) OVER (PARTITION BY tr.cp_id_trilha), 2) AS percentual
FROM tbl_trilha tr
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
INNER JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
WHERE rev.recomendacao IS NOT NULL
GROUP BY tr.cp_id_trilha, tr.nm_trilha, rev.recomendacao;

-- 37. Autores com mais submissões no ano (RF42 - xv) | Funções: JOIN, GROUP BY, COUNT, WINDOW
SELECT p.nm_pessoa, COUNT(sub.cp_id_submissao) AS tot, RANK() OVER (ORDER BY COUNT(sub.cp_id_submissao) DESC) AS rank
FROM tbl_pessoa p
INNER JOIN tbl_escreve esc ON p.cp_id_pessoa = esc.ce_pessoa
INNER JOIN tbl_submissao sub ON esc.ce_submissao = sub.cp_id_submissao
INNER JOIN tbl_trilha tr ON sub.ce_trilha = tr.cp_id_trilha
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
WHERE ed.ano_edicao = 2023
GROUP BY p.nm_pessoa;

-- 38. Revisões atrasadas (RF42 - vi) | Funções: JOIN, SUB-CONSULTA
SELECT tr.nm_trilha, p.nm_pessoa, tr.dt_fim_revisoes, rev.dt_submissao
FROM tbl_trilha tr
INNER JOIN tbl_submissao sub ON tr.cp_id_trilha = sub.ce_trilha
INNER JOIN tbl_atribuicao_revisao atr ON sub.cp_id_submissao = atr.ce_submissao
INNER JOIN tbl_revisao rev ON atr.cp_id_atribuicao = rev.ce_atribuicao
INNER JOIN tbl_comite com ON atr.ce_revisor = com.cp_id_comite
INNER JOIN tbl_pessoa p ON com.ce_pessoa = p.cp_id_pessoa
WHERE rev.dt_submissao > (SELECT tr2.dt_fim_revisoes FROM tbl_trilha tr2 WHERE tr2.cp_id_trilha = tr.cp_id_trilha);

-- 39. Trabalhos aceitos sem versão final (RF42 - xiv) | Funções: JOIN, SUB-CONSULTA
SELECT sub.titulo_submissao, tr.nm_trilha
FROM tbl_submissao sub
INNER JOIN tbl_trilha tr ON sub.ce_trilha = tr.cp_id_trilha
WHERE sub.status_submissao = 'ACEITA' AND NOT EXISTS (
    SELECT 1 FROM tbl_versao_submissao ver WHERE ver.ce_submissao = sub.cp_id_submissao AND ver.tp_versao = 'FINAL'
);

-- 40. Cobertura temática do comitê (RF42 - vii) | Funções: JOIN, GROUP BY, COUNT, SUB-CONSULTA
SELECT top.nm_topico, 
       (SELECT COUNT(*) FROM tbl_aborda ab WHERE ab.ce_topico = top.cp_id_topico) AS demanda,
       (SELECT COUNT(*) FROM tabela_imp_tem_interesse ti INNER JOIN tbl_comite c ON ti.ce_pessoa = c.ce_pessoa WHERE ti.ce_topico = top.cp_id_topico) AS oferta
FROM tbl_topico top
INNER JOIN tbl_trilha tr ON top.ce_trilha = tr.cp_id_trilha;

-- 41. Taxa de aceitação por trilha (RF42 - xii) | Funções: JOIN, GROUP BY, COUNT, SUB-CONSULTA
SELECT tr.nm_trilha, 
       (COUNT(CASE WHEN s.status_submissao = 'ACEITA' THEN 1 END) * 100.0 / COUNT(s.cp_id_submissao)) as taxa_aceitacao
FROM tbl_trilha tr
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
INNER JOIN tbl_edicao ed ON tr.ce_edicao = ed.cp_id_edicao
GROUP BY tr.nm_trilha;

-- 42. Especialistas presentes em todas as trilhas (RF10) | Funções: JOIN, GROUP BY, COUNT, SUB-CONSULTA
SELECT p.nm_pessoa
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_trilha tr ON c.ce_trilha = tr.cp_id_trilha
GROUP BY p.nm_pessoa
HAVING COUNT(DISTINCT tr.cp_id_trilha) = (SELECT COUNT(*) FROM tbl_trilha);

-- 43. Rank de revisores por recusas (RF15) | Funções: JOIN, GROUP BY, COUNT, WINDOW
SELECT p.nm_pessoa, COUNT(atr.cp_id_atribuicao) as num_recusas,
       RANK() OVER(ORDER BY COUNT(atr.cp_id_atribuicao) DESC) as rank_recusas
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON c.cp_id_comite = atr.ce_revisor
WHERE atr.status_atribuicao = 'RECUSADA'
GROUP BY p.nm_pessoa;

-- 44. Média das notas das instituições (RF42) | Funções: JOIN, GROUP BY, WINDOW, SUB-CONSULTA
SELECT i.nm_instituicao, AVG(r.nota_geral) as media_inst,
       AVG(AVG(r.nota_geral)) OVER() as media_global
FROM tbl_instituicao i
INNER JOIN tbl_vinculo_institucional vi ON i.cp_id_instituicao = vi.ce_instituicao
INNER JOIN tbl_escreve e ON vi.ce_pessoa = e.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON e.ce_submissao = atr.ce_submissao
INNER JOIN tbl_revisao r ON atr.cp_id_atribuicao = r.ce_atribuicao
GROUP BY i.nm_instituicao;

-- 45. Soma cumulativa de trabalhos por evento (RF42 - xiii) | Funções: JOIN, GROUP BY, COUNT, WINDOW
SELECT ev.nm_evento, CAST(s.dt_registro AS DATE) as data_reg, COUNT(s.cp_id_submissao) as qtd_dia,
       SUM(COUNT(s.cp_id_submissao)) OVER(PARTITION BY ev.nm_evento ORDER BY CAST(s.dt_registro AS DATE)) as cumulativo
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
GROUP BY ev.nm_evento, CAST(s.dt_registro AS DATE);

-- 46. Aceitos com nota menor que um rejeitado (RF31) | Funções: JOIN, SUB-CONSULTA
SELECT s_aceito.titulo_submissao, r_aceito.nota_geral
FROM tbl_submissao s_aceito
INNER JOIN tbl_atribuicao_revisao atr_a ON s_aceito.cp_id_submissao = atr_a.ce_submissao
INNER JOIN tbl_revisao r_aceito ON atr_a.cp_id_atribuicao = r_aceito.ce_atribuicao
WHERE s_aceito.status_submissao = 'ACEITA' AND r_aceito.nota_geral < ANY (
    SELECT r_rej.nota_geral 
    FROM tbl_submissao s_rej 
    INNER JOIN tbl_atribuicao_revisao atr_r ON s_rej.cp_id_submissao = atr_r.ce_submissao
    INNER JOIN tbl_revisao r_rej ON atr_r.cp_id_atribuicao = r_rej.ce_atribuicao 
    WHERE s_rej.status_submissao = 'REJEITADA' AND s_rej.ce_trilha = s_aceito.ce_trilha
);

-- 47. Crescimento de edições (RF42 - i) | Funções: JOIN, GROUP BY, COUNT, WINDOW
SELECT ev.nm_evento, ed.ano_edicao, COUNT(s.cp_id_submissao) as total,
       LAG(COUNT(s.cp_id_submissao)) OVER (PARTITION BY ev.cp_id_evento ORDER BY ed.ano_edicao) as edicao_anterior
FROM tbl_evento ev
INNER JOIN tbl_edicao ed ON ev.cp_id_evento = ed.ce_evento
INNER JOIN tbl_trilha tr ON ed.cp_id_edicao = tr.ce_edicao
INNER JOIN tbl_submissao s ON tr.cp_id_trilha = s.ce_trilha
GROUP BY ev.nm_evento, ev.cp_id_evento, ed.ano_edicao;

-- 48. Submissões onde autor e revisor são do mesmo país mas inst diferentes (RF18) | Funções: JOIN, GROUP BY, SUB-CONSULTA
SELECT s.titulo_submissao
FROM tbl_submissao s
INNER JOIN tbl_escreve e ON s.cp_id_submissao = e.ce_submissao
INNER JOIN tbl_pessoa p_autor ON e.ce_pessoa = p_autor.cp_id_pessoa
WHERE EXISTS (
    SELECT 1 FROM tbl_atribuicao_revisao atr
    INNER JOIN tbl_comite c ON atr.ce_revisor = c.cp_id_comite
    INNER JOIN tbl_pessoa p_rev ON c.ce_pessoa = p_rev.cp_id_pessoa
    WHERE atr.ce_submissao = s.cp_id_submissao AND p_autor.pais_pessoa = p_rev.pais_pessoa AND p_autor.cp_id_pessoa <> p_rev.cp_id_pessoa
)
GROUP BY s.titulo_submissao;

-- 49. Instituições sem trabalhos rejeitados (RF42 - xii) | Funções: JOIN, GROUP BY, SUB-CONSULTA
SELECT i.nm_instituicao 
FROM tbl_instituicao i
INNER JOIN tbl_vinculo_institucional vi ON i.cp_id_instituicao = vi.ce_instituicao
INNER JOIN tbl_escreve e ON vi.ce_pessoa = e.ce_pessoa
INNER JOIN tbl_submissao s ON e.ce_submissao = s.cp_id_submissao
GROUP BY i.nm_instituicao
HAVING SUM(CASE WHEN s.status_submissao = 'REJEITADA' THEN 1 ELSE 0 END) = 0;

-- 50. Revisores que avaliaram as submissões mais bem ranqueadas (RF42 - xi) | Funções: JOIN, GROUP BY, WINDOW, SUB-CONSULTA
WITH RankSubs AS (
    SELECT s.cp_id_submissao, RANK() OVER(ORDER BY AVG(r.nota_geral) DESC) as rk
    FROM tbl_submissao s
    INNER JOIN tbl_atribuicao_revisao atr ON s.cp_id_submissao = atr.ce_submissao
    INNER JOIN tbl_revisao r ON atr.cp_id_atribuicao = r.ce_atribuicao
    GROUP BY s.cp_id_submissao
)
SELECT p.nm_pessoa, COUNT(atr.cp_id_atribuicao) as avaliou_top10
FROM tbl_pessoa p
INNER JOIN tbl_comite c ON p.cp_id_pessoa = c.ce_pessoa
INNER JOIN tbl_atribuicao_revisao atr ON c.cp_id_comite = atr.ce_revisor
WHERE atr.ce_submissao IN (SELECT cp_id_submissao FROM RankSubs WHERE rk <= 10)
GROUP BY p.nm_pessoa;