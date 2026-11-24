
#' Estado de los ensayos clinicos por patologia en AACT
#'
#' Consulta la base de datos AACT y devuelve el numero de
#' ensayos clinicos y su reclutamiento medio segun el
#' estado del estudio para una determinada patologia.
#'
#' @param patologia Nombre de la enfermedad que se desea consultar.
#'
#' @return Un data.frame con el estado de los ensayos,
#'   el numero de estudios y el reclutamiento medio.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' estado_ensayos_aact("Diabetes")
#' }

estado_ensayos_aact <- function(patologia = "Diabetes") {

  usuario <- Sys.getenv("AACT_USER")
  clave <- Sys.getenv("AACT_PASSWORD")

  if (usuario == "" || clave == "") {
    stop("Configura AACT_USER y AACT_PASSWORD en .Renviron.")
  }

  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = "aact",
    host = "aact-db.ctti-clinicaltrials.org",
    port = 5432,
    user = usuario,
    password = clave
  )

  on.exit(DBI::dbDisconnect(con), add = TRUE)

  consulta_sql <- "
    SELECT
      estado,
      COUNT(*) AS num_ensayos,
      ROUND(AVG(enrollment), 1) AS reclutamiento_medio
    FROM (
      SELECT DISTINCT
        s.nct_id,
        COALESCE(s.overall_status, 'No especificado') AS estado,
        s.enrollment
      FROM ctgov.studies s
      INNER JOIN ctgov.conditions c
        ON s.nct_id = c.nct_id
      WHERE LOWER(c.name) LIKE LOWER($1)
    ) AS ensayos
    GROUP BY estado
    ORDER BY num_ensayos DESC;
  "

  DBI::dbGetQuery(
    con,
    consulta_sql,
    params = list(paste0("%", patologia, "%"))
  )
}
