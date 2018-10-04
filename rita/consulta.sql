USE federacao_tenis;

-- 1) Ta funcionando
SELECT nome AS 'campeonato', premiacao FROM campeonatos WHERE data_realizacao < '2016-01-01';

-- 2) Ta funcionando
SELECT tenistas.nome, categorias.nome FROM tenistas
  JOIN categorias ON tenistas.categorias_id = categorias.id;

-- 3) Ta funcionando
SELECT quadras.endereco, SUM(jogos.publico) FROM jogos
  JOIN quadras ON jogos.quadras_id = quadras.id
  GROUP BY quadras.endereco;

-- 4) Ta funcionando, meu deus eu sou mto boa
SELECT t1.nome, jogos.pontuacao_tenista_01, t2.nome, jogos.pontuacao_tenista_02, campeonatos.nome, quadras.tipo FROM jogos
  JOIN tenistas t1 ON jogos.tenista_01_id = t1.id
  JOIN tenistas t2 ON jogos.tenista_02_id = t2.id
  JOIN campeonatos ON jogos.campeonatos_id = campeonatos.id
  JOIN quadras ON jogos.quadras_id = quadras.id;

-- 5) NEM ACREDITO QUE FUNCIONOU
SELECT campeonatos.nome AS 'campeonato', tenistas.nome AS 'tenista', COUNT(tenistas.id) AS 'jogos' FROM tenistas
  INNER JOIN jogos ON jogos.tenista_01_id = tenistas.id OR jogos.tenista_02_id = tenistas.id
  INNER JOIN campeonatos ON jogos.campeonatos_id = campeonatos.id
  GROUP BY tenistas.nome, campeonatos.nome;

-- 6) FOI
SELECT campeonatos.nome, ROUND(AVG(jogos.publico),2) AS 'média' , campeonatos.premiacao FROM campeonatos
  LEFT OUTER JOIN jogos ON jogos.campeonatos_id = campeonatos.id
  GROUP BY campeonatos.id;

-- 7) NASS, MONGO E MTO MELHOR, MEU DEUS (MAS FOI)
SELECT year(campeonato.data_realizacao) AS 'data de realização', count(t.id) AS `quantidade de jogos`, t.nome
	FROM jogos jogos
    INNER JOIN campeonatos campeonato
		ON campeonato.id = jogos.campeonatos_id
    INNER JOIN tenistas t
		ON t.id = jogos.tenista_01_id || t.id = jogos.tenista_02_id
    GROUP BY Year(campeonato.data_realizacao), t.id ORDER BY `data de realização` DESC;

-- 8) ACHO Q FOI
SELECT quadras.endereco, ROUND(AVG(jogos.publico),2) AS 'média' FROM quadras
  LEFT OUTER JOIN jogos ON jogos.quadras_id = quadras.id
  JOIN campeonatos ON jogos.campeonatos_id = campeonatos.id
  WHERE Year(campeonatos.data_realizacao) = '2014'
  GROUP BY quadras.id ORDER BY `média` DESC;

-- 9) ah vei, se daniel san for uma mulher deu certo
SELECT tenistas.nome, COUNT(*) AS vitorias FROM tenistas
  JOIN jogos
    ON tenistas.id = jogos.tenista_01_id OR tenistas.id = jogos.tenista_02_id
  WHERE tenistas.sexo = 0
    AND ((jogos.pontuacao_tenista_01 > jogos.pontuacao_tenista_02 AND tenistas.id = jogos.tenista_01_id)
    OR (jogos.pontuacao_tenista_02 > jogos.pontuacao_tenista_01 AND tenistas.id = jogos.tenista_02_id))
  GROUP BY (tenistas.nome)
  HAVING COUNT(*) >= 3;

-- 10) DEU CERTO GRR
SELECT tenistas.nome, AVG(jogos.publico) AS media_publico FROM tenistas
  JOIN jogos ON tenistas.id = jogos.tenista_01_id OR tenistas.id = jogos.tenista_02_id
  GROUP BY (tenistas.nome)
  ORDER BY AVG(jogos.publico) DESC LIMIT 1;

-- EXTRA) NUUUUU FOI
SELECT tenistas.nome, COUNT(*) AS vitorias FROM tenistas
  JOIN jogos
    ON tenistas.id = jogos.tenista_01_id OR tenistas.id = jogos.tenista_02_id
  WHERE (jogos.pontuacao_tenista_01 > jogos.pontuacao_tenista_02 AND tenistas.id = jogos.tenista_01_id)
    OR (jogos.pontuacao_tenista_02 > jogos.pontuacao_tenista_01 AND tenistas.id = jogos.tenista_02_id)
  GROUP BY (tenistas.nome)
  ORDER BY COUNT(*) DESC
  LIMIT 1;
