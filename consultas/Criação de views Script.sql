-- 1 Quais os 10 produtos que mais foram cancelados.

DROP VIEW IF EXISTS produtos_mais_cancelados;
CREATE VIEW produtos_mais_cancelados AS
SELECT "Produto", COUNT(*) AS quantidade
FROM produtos p 
INNER JOIN vendas v ON p."Codigo" = v."Codigo" 
AND v."Courier Status" = 'Cancelled'
GROUP BY "Produto" 
ORDER BY quantidade DESC
LIMIT 10; 

SELECT * FROM produtos_mais_cancelados;

-- 2 Quais os 5 países que mais fizeram requisição de pedidos e que foram enviados

DROP VIEW IF EXISTS paises_maior_requisicoes_enviadas;
CREATE VIEW paises_maior_requisicoes_enviadas AS  
SELECT "ship-country", COUNT(*) AS quantidade_pedidos
FROM vendas v 
WHERE "Courier Status" = 'Shipped'
GROUP BY "ship-country"
ORDER BY quantidade_pedidos DESC 
LIMIT 5;

SELECT * FROM paises_maior_requisicoes_enviadas;

-- 3 Qual o mês com maior número de requisições

DROP VIEW IF EXISTS mes_maior_quantidade;
CREATE VIEW mes_maior_quantidade AS
SELECT mes, SUM("Qty") AS quantidade
FROM (
    SELECT
    	"Qty", 
        SPLIT_PART("Date", '/', 1)::INTEGER AS mes,
        SPLIT_PART("Date", '/', 2)::INTEGER AS dia,
        SPLIT_PART("Date", '/', 3)::INTEGER AS ano
    FROM vendas 
) AS subquery
GROUP BY mes
ORDER BY quantidade DESC 
LIMIT 1;

SELECT * FROM mes_maior_quantidade ;

-- 4 Quais os cinco produtos com maior quantidade de solicitações

DROP VIEW IF EXISTS produtos_mais_solicitados;
CREATE VIEW produtos_mais_solicitados AS
SELECT p."Produto", SUM(v."Qty") AS quantidade
FROM produtos p 
INNER JOIN vendas v ON p."Codigo" = v."Codigo"
GROUP BY p."Produto"
ORDER BY quantidade DESC
LIMIT 5;

SELECT * FROM produtos_mais_solicitados;

-- 5 Quais os cinco produtos com menor quantidade de solicitações

DROP VIEW IF EXISTS produtos_menos_solicitados;
CREATE VIEW produtos_menos_solicitados AS
SELECT p."Produto", SUM(v."Qty") AS quantidade
FROM produtos p 
INNER JOIN vendas v ON p."Codigo" = v."Codigo"
GROUP BY p."Produto"
ORDER BY quantidade ASC
LIMIT 5;

SELECT * FROM produtos_menos_solicitados;

-- 6 Qual o mês com menor número de requisições

DROP VIEW IF EXISTS mes_menor_quantidade;
CREATE VIEW mes_menor_quantidade AS
SELECT mes, SUM("Qty") AS quantidade
FROM (
    SELECT
    	"Qty", 
        SPLIT_PART("Date", '/', 1)::INTEGER AS mes,
        SPLIT_PART("Date", '/', 2)::INTEGER AS dia,
        SPLIT_PART("Date", '/', 3)::INTEGER AS ano
    FROM vendas 
) AS subquery
GROUP BY mes
ORDER BY quantidade ASC 
LIMIT 1;

SELECT * FROM mes_menor_quantidade ;

-- 7 Quais os 5 países que menos fizeram requisição de pedidos e que foram enviados

DROP VIEW IF EXISTS paises_menor_requisicoes_enviadas;
CREATE VIEW paises_menor_requisicoes_enviadas AS  
SELECT "ship-country", COUNT(*) AS quantidade_pedidos
FROM vendas v 
WHERE "Courier Status" = 'Shipped'
GROUP BY "ship-country"
ORDER BY quantidade_pedidos ASC  
LIMIT 5;

SELECT * FROM paises_menor_requisicoes_enviadas;

-- 8 Quais os 10 produtos que mais foram enviados.

DROP VIEW IF EXISTS produtos_mais_enviados;
CREATE VIEW produtos_mais_enviados AS
SELECT "Produto", COUNT(*) AS quantidade
FROM produtos p 
INNER JOIN vendas v ON p."Codigo" = v."Codigo" 
AND v."Courier Status" = 'Shipped'
GROUP BY "Produto" 
ORDER BY quantidade ASC
LIMIT 10; 

SELECT * FROM produtos_mais_enviados;

-- 9 Encontrar a quantidade de produtos vendidos em cada venda:

DROP VIEW IF EXISTS produtos_vendidos_por_venda;
CREATE VIEW produtos_vendidos_por_venda AS 
SELECT "Order ID", COUNT(*) AS "Quantidade de Produtos Vendidos" 
FROM vendas GROUP BY "Order ID";

SELECT * FROM produtos_vendidos_por_venda;

-- 10 Buscar produtos que não foram vendidos (não estão na tabela "vendas"):

DROP VIEW IF EXISTS produtos_nao_vendidos;
CREATE VIEW produtos_nao_vendidos AS
SELECT * 
FROM produtos 
WHERE "Codigo" NOT IN (SELECT "Codigo" FROM vendas);

SELECT * FROM produtos_nao_vendidos;

-- 11 Calcular o total de gastos com produtos cancelados:

DROP VIEW IF EXISTS total_gastos_produtos_cancelados;
CREATE VIEW total_gastos_produtos_cancelados AS 
SELECT "Produto", SUM((CAST(SUBSTRING(produtos."Preco" FROM 2) AS NUMERIC)) * vendas."Qty") AS "Total Gasto"
FROM produtos 
JOIN vendas 
ON produtos."Codigo" = vendas."Codigo" 
AND "Courier Status" = 'Cancelled'
GROUP BY "Produto";

SELECT * FROM total_gastos_produtos_cancelados;

-- 12 Calcular o valor total de produtos enviados

DROP VIEW IF EXISTS total_gastos_produtos_enviados;
CREATE VIEW total_gastos_produtos_enviados AS 
SELECT "Produto", SUM((CAST(SUBSTRING(produtos."Preco" FROM 2) AS NUMERIC)) * vendas."Qty") AS "Total Gasto"
FROM produtos 
JOIN vendas 
ON produtos."Codigo" = vendas."Codigo" 
AND "Courier Status" = 'Shipped'
GROUP BY "Produto";

SELECT * FROM total_gastos_produtos_enviados;

-- 13 Calcular o valor total de produtos enviados por país

DROP VIEW IF EXISTS total_gastos_produtos_enviados_pais;
CREATE VIEW total_gastos_produtos_enviados_pais AS 
SELECT "ship-country", SUM((CAST(SUBSTRING(produtos."Preco" FROM 2) AS NUMERIC)) * vendas."Qty") AS "Total Gasto"
FROM produtos 
JOIN vendas 
ON produtos."Codigo" = vendas."Codigo" 
AND "Courier Status" = 'Shipped'
GROUP BY "ship-country";

SELECT * FROM total_gastos_produtos_enviados_pais;

-- 14 Calcular o valor total de produtos cancelados por país

DROP VIEW IF EXISTS total_gastos_produtos_cancelados_pais;
CREATE VIEW total_gastos_produtos_cancelados_pais AS 
SELECT "ship-country", SUM((CAST(SUBSTRING(produtos."Preco" FROM 2) AS NUMERIC)) * vendas."Qty") AS "Total Gasto"
FROM produtos 
JOIN vendas 
ON produtos."Codigo" = vendas."Codigo" 
AND "Courier Status" = 'Cancelled'
GROUP BY "ship-country";

SELECT * FROM total_gastos_produtos_cancelados_pais;

-- 15 Encontrar o valor total do produto mais vendido:

DROP VIEW IF EXISTS total_valor_produtos_vendido;
CREATE VIEW total_valor_produtos_vendido AS 
SELECT produtos."Produto", SUM((CAST(SUBSTRING(produtos."Preco" FROM 2) AS NUMERIC)) * vendas."Qty") AS "Valor Total" 
FROM produtos 
JOIN vendas 
ON produtos."Codigo" = vendas."Codigo" 
GROUP BY produtos."Produto" 
ORDER BY "Valor Total" DESC LIMIT 1;

SELECT * FROM total_valor_produtos_vendido;
