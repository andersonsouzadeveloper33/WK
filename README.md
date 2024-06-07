Para criar o banco:

1º Rodar o script que se encontra em: "/scripts/create schema.txt" para criação do Schema do banco de dados.
2º Rodar os scripts: "/scripts/table_produtos.txt"
                     "/scripts/table_clientes.txt"
                     "/scripts/table_pedidos.txt"
                     "/scripts/table_pedidos_produtos.txt" para criar as tabelas.
3º Rodar os scripts: "/script/insert_produtos.sql"
                     "/script/insert_clientes.sql" para popular as tabelas de produtos e clientes.
                     
A Configuração da conexão está fixa no create do data module:

'Database' := 'wkdatabase';
'User_Name' := 'root';
'Password' := '1234';
'Server' := '127.0.0.1';
'Port' := '3306';
