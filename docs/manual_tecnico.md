# Manual Técnico

## Arquitectura

La aplicación sigue una arquitectura modular basada en Shiny:

- UI: módulos independientes
- Server: reactives controlados
- Análisis: funciones encapsuladas
- Visualización: capa desacoplada

---

## Flujo de datos

Entrada → Reactives → Análisis → Visualización → Exportación

---

## Dependencias

Las dependencias están gestionadas mediante `renv`
para asegurar reproducibilidad.

---

## Extensión del sistema

Se pueden añadir nuevos módulos
siguiendo el patrón existente en `/modules`.
