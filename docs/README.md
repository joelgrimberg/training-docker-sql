# Dierenverzekering — tabellen & relaties

Schema zoals aangemaakt door `docker/init.sql`.

```mermaid
erDiagram
    KLANTEN ||--o{ HUISDIEREN : "heeft"
    HUISDIEREN ||--o{ POLISSEN : "heeft"
    DEKKINGSTYPES ||--o{ POLISSEN : "dekt"
    POLISSEN ||--o{ SCHADES : "heeft"
    POLISSEN ||--o{ BETALINGSGESCHIEDENIS : "heeft"
    SCHADES ||--o{ SCHADE_DOCUMENTEN : "heeft"

    KLANTEN {
        int id PK
        varchar voornaam
        varchar achternaam
        varchar email
        varchar stad
    }
    HUISDIEREN {
        int id PK
        int klant_id FK
        varchar naam
        varchar soort
        varchar ras
    }
    DEKKINGSTYPES {
        int id PK
        varchar naam
        decimal basis_maandpremie
        decimal eigen_risico
    }
    POLISSEN {
        int id PK
        varchar polisnummer
        int huisdier_id FK
        int dekkingstype_id FK
        varchar status
        decimal maandpremie
    }
    SCHADES {
        int id PK
        varchar schadenummer
        int polis_id FK
        varchar diagnose
        decimal totale_kosten
        varchar status
    }
    SCHADE_DOCUMENTEN {
        int id PK
        int schade_id FK
        varchar documenttype
    }
    BETALINGSGESCHIEDENIS {
        int id PK
        int polis_id FK
        decimal bedrag
        varchar betaalmethode
    }
```

## Join-pad

De tabellen vormen één keten — elke stap koppelt via een foreign key aan de vorige:

```
klanten (id) ←── huisdieren (klant_id)
huisdieren (id) ←── polissen (huisdier_id)
dekkingstypes (id) ←── polissen (dekkingstype_id)
polissen (id) ←── schades (polis_id)
polissen (id) ←── betalingsgeschiedenis (polis_id)
schades (id) ←── schade_documenten (schade_id)
```

Dus om bijvoorbeeld van een **schade** terug te komen bij een **klant**, loop je de keten omhoog:
`schades → polissen → huisdieren → klanten`.
