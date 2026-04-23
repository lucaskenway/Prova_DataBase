import psycopg2
import json

try:
    # Conectar ao Postgres
    conn = psycopg2.connect(
        host="localhost",
        port="5432",
        database="loja_virtual",
        user="postgres",
        password="postgres"
    )

    # Ler o JSON
    with open('deep_json.json', 'r') as f:
        data = json.load(f)

    # Inserir
    cur = conn.cursor()
    cur.execute("INSERT INTO json_test (data) VALUES (%s)", (json.dumps(data),))
    conn.commit()

    cur.close()
    conn.close()

    print("JSON inserido no Postgres.")
except Exception as e:
    print(f"Erro: {e}")