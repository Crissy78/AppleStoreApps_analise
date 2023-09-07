--Vizualizando a tabela AppleStore
SELECT * FROM AppleStore;

--Unindo as tabelas 'Apple_description'
create table AppleStore_description_combined as

SELECT * FROM appleStore_description1

union all

SELECT * FROM appleStore_description2

union all

SELECT * FROM appleStore_description3

UNION all

SELECT * FROM appleStore_description4;

--Vizualização da tabela 'Apple_description_conbined'
SELECT * from AppleStore_description_combined;

*Exploração dos dados*

--Descrevendo as tabelas
PRAGMA table_info(AppleStore);

PRAGMA table_info(AppleStore_description_combined);

--Checando as duplicatas das duas tabelas
select count (DISTINCT id) as Ids_unicos from AppleStore;

SELECT count (DISTINCT id) as Ids_unicos from AppleStore_description_combined;

--Checando valores Nulos 
SELECT COUNT(*) as valores_nulos
FROM AppleStore
where track_name is null or user_rating is null or prime_genre is null ;

SELECT COUNT(*) as valores_nulos
FROM AppleStore_description_combined
where app_desc is null;

--Estatisticas das principais variáveis quantitativas
SELECT
min(user_rating) as Minima_aval,
max(user_rating) as Maxima_aval,
round(avg(user_rating),2) as Media_aval,
min(price) as Minimo_preco,
max(price) as Maxima_preco,
round(avg(size_bytes),2) as Media_tam,
min(size_bytes) as Minima_tam,
max(size_bytes) as Maxima_tam,
round(avg(size_bytes),2) as Media_tam
FROM AppleStore;

*ANÁLISE*
--Contagem de Total de Apps
SELECT count (DISTINCT id)
from AppleStore; 

--Contagem de Apps por gênero
select prime_genre, count(*) as Contagem_apps
from AppleStore
GROUP by prime_genre
order by contagem_apps DESC;

--Contagem de Apps entre Gratuitos e Pagos
SELECT COUNT(prime_genre),
Case when price = 0 then 'Gratis' 
ELSE 'Pago' end as Apptype
FROM AppleStore
group by AppType;

--Média de Avaliações por gênero e contagem
SELECT 
prime_genre,
ROUND(AVG(user_rating),2) As Media,
COUNT(user_rating) as Contagem_apps
FROM AppleStore
group by prime_genre
ORDER BY 2 DESC;

--Verificando generos com mais altas e baixas avaliações
SELECT prime_genre, 
	   round(avg(user_rating),2) as media_aval
from AppleStore
group by prime_genre
order by media_aval DESC
limit 10;

SELECT prime_genre, 
	   round(avg(user_rating),2) as media_aval
from AppleStore
group by prime_genre
order by media_aval ASC
limit 10;

--Media de preços dos apps pagos
SELECT ROUND(AVG(price),2) AS Média_apps_pagos
FROM AppleStore
WHERE price > 0;

--Os 10 apps mais caros
SELECT track_name,price
FROM AppleStore
WHERE price > 0
ORDER BY price DESC
LIMIT 10;

--Verificando se apps pagos tem melhor avaliação que os gratuitos
SELECT 
 	case when price > 0 then 'Pago'
    else 'Gratis'
    end as App_type, 
    round(avg(user_rating),2) as media_aval
from AppleStore
group by App_type
ORDER by media_aval Desc;

--Verificando se apps com mais linguagens disponivéis tem maior avaliação
SELECT 
	case WHEN lang_num < 10 then '<10 Línguas'
	when lang_num BETWEEN 10 and 30 then '10 a 30 línguas'
    ELSE '> 30 línguas'
    end as Numero_de_linguagens,
    round(avg(user_rating),2) as media_aval
FROM AppleStore
GROUP by Numero_de_linguagens
order by media_aval desc;

-- Verificando se o tamanho da descrição do app influencia na avalição
SELECT 
	case when length(tb2.app_desc) < 500 then 'Curta'
    	 when length(tb2.app_desc) BETWEEN 500 and 1000 then 'Media'
         else 'Longa' 
         end as tamanho_da_descricao,
         round(avg(user_rating),2) as media_aval
from AppleStore as tb1
join AppleStore_description_combined as tb2 on tb1.id= tb2.id
GROUP by tamanho_da_descricao
order by media_aval desc;

--Verificando os apps mais bem avaliados por genero
select prime_genre,
	  track_name,
      user_rating
from (select prime_genre,
	  	  track_name,
     	  user_rating,
    RANK() OVER (Partition by prime_genre order by user_rating desc, rating_count_tot desc)
      as rank
  from AppleStore) as tb
  where tb.rank= 1;

