
# Consultas de ensayos clínicos en AACT

## Descripción

Este paquete de R permite consultar de forma remota la base de datos AACT (Aggregate Analysis of ClinicalTrials.gov), que contiene información sobre ensayos clínicos registrados en ClinicalTrials.gov.

Su objetivo es facilitar el análisis bioestadístico de los ensayos clínicos mediante consultas SQL a una base de datos PostgreSQL, sin necesidad de descargar grandes volúmenes de información.

## Instalación

El paquete puede instalarse directamente desde GitHub mediante los siguientes comandos de R:

```r
install.packages("remotes")
remotes::install_github("TU_USUARIO_GITHUB/TU_PAQUETE")
```

Una vez instalado, se puede cargar mediante:

```r
library(TU_PAQUETE)
```

## Configuración de las credenciales de AACT

Para utilizar las funciones del paquete es necesario disponer de una cuenta gratuita en AACT:

https://aact.ctti-clinicaltrials.org/

Una vez obtenidos el usuario y la contraseña, se debe abrir el archivo `.Renviron` ejecutando:

```r
usethis::edit_r_environ()
```

En este archivo deben añadirse las siguientes variables de entorno, sustituyendo los valores por las credenciales personales:

```
AACT_USER=tu_usuario_aact
AACT_PASSWORD=tu_password_aact
```

Después, se debe guardar el archivo y reiniciar la sesión de R.

Esta configuración permite establecer la conexión con AACT sin incluir credenciales personales en el código fuente del paquete ni en el repositorio público de GitHub.

## Tablas consultadas

El paquete realiza consultas SQL sobre las siguientes tablas del esquema `ctgov` de AACT:

- `ctgov.studies`: contiene información general sobre los ensayos clínicos, incluyendo su identificador, fase clínica, estado y tamaño muestral.
- `ctgov.conditions`: contiene las enfermedades y condiciones clínicas asociadas a cada ensayo.

Ambas tablas se relacionan mediante el identificador único `nct_id`, utilizando operaciones `INNER JOIN`.

## Funciones disponibles

### resumen_ensayos_aact()

Permite obtener el número de ensayos clínicos y el reclutamiento medio por fase clínica para una determinada enfermedad.

Ejemplo de uso:

```r
resumen_ensayos_aact("Melanoma")
resumen_ensayos_aact("Diabetes")
```

### estado_ensayos_aact()

Permite analizar el número de ensayos clínicos y su reclutamiento medio según el estado del estudio para una determinada enfermedad.

La función evita contabilizar varias veces un mismo ensayo cuando este se encuentra asociado a varias condiciones clínicas coincidentes.

Ejemplo de uso:

```r
estado_ensayos_aact("Diabetes")
estado_ensayos_aact("Alzheimer")
```

## Dependencias

El paquete utiliza las siguientes librerías de R:

- `DBI`: interfaz para la conexión y consulta de bases de datos.
- `RPostgres`: conexión con servidores PostgreSQL.

## Fuente de los datos

Los datos proceden de AACT y ClinicalTrials.gov:

- https://aact.ctti-clinicaltrials.org/
- https://clinicaltrials.gov/

## Contexto académico

Este paquete ha sido desarrollado como parte de una práctica individual del Máster en Bioestadística de la Universidad Complutense de Madrid, orientada a la ciencia reproducible, la programación de paquetes en R, las consultas SQL remotas y el control de versiones mediante Git y GitHub.


