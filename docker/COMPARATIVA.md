# Docker Manual vs Docker Compose

|                  | Docker Manual                                                                 | Docker Compose                                              |
| ---------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------- |
| Tiempo           | Es lento, cada comando debe ejecutarse manualmente                            | Es rapido, con un solo comando se levanta el stack completo |
| Complejidad      | Mucha, hay que recordar comandos, flags y el orden correcto                   | Simple, todo queda declarado en un solo archivo             |
| Reproducibilidad | Dificil, porque se debe ejecutar una lista de comandos en el mismo orden      | Facil, un solo comando                                      |
| Mantenimiento    | Dificil, cambios implican rehacer comandos a mano, hay que definir estandares | Facil, se cambia el yaml el cual sigue estandares           |
| CI/CD            | No es practico                                                                | Es practico y mas ordenado                                  |
