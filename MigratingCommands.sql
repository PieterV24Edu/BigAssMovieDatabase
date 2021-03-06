--Add data to schrijver table
INSERT INTO bigmovie.schrijver (
  SELECT DISTINCT name, lastname FROM "bigmovieStaging".writers
);

--Add data to geboorteplaats table
INSERT INTO bigmovie.geboorteplaatsen (geboorteplaats, coords)
    SELECT birthplace, coords FROM "bigmovieStaging".birthplaces;

--Add data to genre table
INSERT INTO bigmovie.genre (
  SELECT DISTINCT genre FROM "bigmovieStaging".genres
);

--Add data to land table
INSERT INTO bigmovie.land (
  SELECT DISTINCT country FROM "bigmovieStaging"."production-companies"
);

--Add data to director table
INSERT INTO bigmovie.regiseur (
  SELECT DISTINCT name FROM "bigmovieStaging".directors
);

--Add movies to videomateriaal table
INSERT INTO bigmovie.videomateriaal(naam, jaar, isserie) (
    SELECT DISTINCT name, releaseyear, videos.isserie FROM "bigmovieStaging".videos
);

--Add actors to acteur table
INSERT INTO bigmovie.acteur (naam, isman) (
  SELECT DISTINCT name, ismale FROM "bigmovieStaging".actors
);

--Add movie runtime to corresponding movie
UPDATE bigmovie.videomateriaal AS new
  SET duur = stage.runtime
  FROM "bigmovieStaging"."running-times" AS stage
  WHERE (new.naam = stage.moviename AND new.jaar = stage.releaseyear AND new.isserie = stage.isserie)
        AND (new.isserie = FALSE OR stage.isserie = FALSE);

--Add average runtime to series
UPDATE bigmovie.videomateriaal AS new
  SET duur = stage.runtime
  FROM (
      SELECT moviename, releaseyear, AVG(runtime) AS runtime, "running-times".isserie FROM "bigmovieStaging"."running-times"
      WHERE "running-times".isserie
      GROUP BY moviename, releaseyear, "running-times".isserie
       )AS stage
  WHERE (new.naam = stage.moviename AND new.jaar = stage.releaseyear AND new.isserie = stage.isserie);

--Add birthplaces to actors
UPDATE bigmovie.acteur AS new
  SET geboorteplaats = stage.birthplace
  FROM (SELECT * FROM "bigmovieStaging".biographies) AS stage
  WHERE stage.name = new.naam;

--Add Mpaa ratings to videomateriaal
UPDATE bigmovie.videomateriaal AS new
  SET leeftijdcat = stage.rating
  FROM "bigmovieStaging"."MPAA-ratings" as stage
  WHERE new.naam = stage.moviename AND new.jaar = stage.releaseyear AND new.isserie = stage.inserie;

--add movie rating to videomateriaal
UPDATE bigmovie.videomateriaal AS new
  SET beoordeling = stage.rating
  FROM "bigmovieStaging".ratings as stage
  WHERE new.naam = stage.moviename AND new.jaar = stage.releaseyear AND new.isserie = stage.isserie AND stage.isserie = FALSE;

--Add average rating to series in videomateriaal
UPDATE bigmovie.videomateriaal AS new
  SET beoordeling = stage.rating
  FROM (
      SELECT moviename, releaseyear, AVG(rating) AS rating, ratings.isserie FROM "bigmovieStaging".ratings
      WHERE ratings.isserie = FALSE
      GROUP BY moviename, releaseyear, ratings.isserie) AS stage
  WHERE new.naam = stage.moviename AND new.jaar = stage.releaseyear AND new.isserie = stage.isserie;


--Add references between movies/series and genres
INSERT INTO bigmovie.videogenre (genretype, videomateriaalnaam, videomateriaaljaar, isserie)
    SELECT DISTINCT stage.genre, stage.moviename, stage.releaseyear, stage.isserie FROM "bigmovieStaging".genres AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.releaseyear = ref.jaar AND stage.isserie = ref.isserie;

--Add references between movies/series and countries
INSERT INTO bigmovie.videoland (landnaam, videomateriaalnaam, videomateriaaljaar, isserie)
    SELECT DISTINCT stage.country, stage.moviename, stage.releaseyear, stage.isserie FROM "bigmovieStaging"."production-companies" AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.releaseyear = ref.jaar AND stage.isserie = ref.isserie;

--Add references between movies/series and directors
INSERT INTO bigmovie.videoregiseur (regiseurnaam, videomateriaalnaam, videomateriaaljaar, isserie)
    SELECT DISTINCT stage.name, stage.moviename, stage.releaseyear, stage.isserie FROM "bigmovieStaging".directors AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.releaseyear = ref.jaar AND stage.isserie = ref.isserie
      WHERE stage.name IN (SELECT regiseur.naam FROM bigmovie.regiseur)

--Add references between movies/series and writers
INSERT INTO bigmovie.videoschrijver (schrijvernaam, videomateriaalnaam, videomateriaaljaar, isserie, schrijverachternaam)
    SELECT DISTINCT stage.name, stage.moviename, stage.releaseyear, stage.isserie, stage.lastname FROM "bigmovieStaging".writers AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.releaseyear = ref.jaar AND stage.isserie = ref.isserie
      WHERE (stage.name, stage.lastname) IN (SELECT schrijver.naam, schrijver.achternaam  FROM bigmovie.schrijver)

--Add references between movies/series and actors
INSERT INTO bigmovie.rol (acteurnaam, videomateriaalnaam, videomateriaaljaar, isserie, rolnaam, priroriteit, isman)
    SELECT DISTINCT stage.name, stage.moviename, stage.releaseyear, stage.isserie, stage.role, stage.payroll, stage.ismale FROM "bigmovieStaging".actors AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.releaseyear = ref.jaar AND stage.isserie = ref.isserie
      WHERE (stage.name) IN (SELECT acteur.naam FROM bigmovie.acteur);

--Add references between movies/series and their income
INSERT INTO bigmovie.opbrengsten(videomateriaalnaam, videomateriaaljaar, isserie, valuta, hoeveelheid, origine)
    SELECT DISTINCT stage.moviename, stage.movieyear, stage.isserie, stage.currency, stage.amount, stage.type FROM "bigmovieStaging".business AS stage
      INNER JOIN bigmovie.videomateriaal AS ref
      ON stage.moviename = ref.naam AND stage.movieyear = ref.jaar AND stage.isserie = ref.isserie;
