import random
from faker import Faker

fake = Faker('pt_BR')
QTD_REGISTROS = 5000

def gerar_sql_ansi():
    with open('popula_5k_novo.sql', 'w', encoding='utf-8') as f:
        f.write("-- Script DML de Povoamento em Massa (SQL ANSI)\n")
        f.write("-- Tabelas com no mínimo 5000 registros para o MATA60\n\n")
        
        # 1. Gerar Instituições
        f.write("-- Povoando tbl_instituicao\n")
        f.write("INSERT INTO tbl_instituicao (nm_instituicao, sg_instituicao, pais_instituicao, cidade_instituicao, uf_instituicao) VALUES\n")
        instituicoes = []
        for _ in range(QTD_REGISTROS):
            nm = fake.company()[:200].replace("'", "''")
            sg = fake.company_suffix()[:30].replace("'", "''")
            pais = 'BR'
            cidade = fake.city()[:100].replace("'", "''")
            uf = fake.estado_sigla()
            instituicoes.append(f"('{nm}', '{sg}', '{pais}', '{cidade}', '{uf}')")
        f.write(",\n".join(instituicoes) + ";\n\n")

        # 2. Gerar Pessoas
        f.write("-- Povoando tbl_pessoa\n")
        f.write("INSERT INTO tbl_pessoa (nm_pessoa, email_principal, cd_orcid, pais_pessoa) VALUES\n")
        pessoas = []
        for _ in range(QTD_REGISTROS):
            nm = fake.name()[:200].replace("'", "''")
            email = fake.unique.email()[:254]
            orcid = f"{random.randint(1000,9999)}-{random.randint(1000,9999)}-{random.randint(1000,9999)}-{random.randint(1000,9999)}"
            pais = 'BR'
            pessoas.append(f"('{nm}', '{email}', '{orcid}', '{pais}')")
        f.write(",\n".join(pessoas) + ";\n\n")

        # 3. Gerar Vínculos Institucionais
        f.write("-- Povoando tbl_vinculo_institucional\n")
        f.write("INSERT INTO tbl_vinculo_institucional (ce_pessoa, ce_instituicao, dt_inicio, dt_fim) VALUES\n")
        vinculos = []
        for i in range(1, QTD_REGISTROS + 1):
            ce_pessoa = i
            ce_instituicao = random.randint(1, QTD_REGISTROS)
            dt_inicio = fake.date_between(start_date='-10y', end_date='-1y').strftime('%Y-%m-%d')
            # 70% de chance do vínculo ainda estar ativo (dt_fim = NULL)
            if random.random() > 0.7:
                dt_fim = f"'{fake.date_between(start_date='-1y', end_date='today').strftime('%Y-%m-%d')}'"
            else:
                dt_fim = "NULL"
            
            vinculos.append(f"({ce_pessoa}, {ce_instituicao}, '{dt_inicio}', {dt_fim})")
        f.write(",\n".join(vinculos) + ";\n\n")

    print(f"Arquivo 'popula_5k_novo.sql' gerado com sucesso com {QTD_REGISTROS} registros para 3 tabelas!")

if __name__ == "__main__":
    gerar_sql_ansi()