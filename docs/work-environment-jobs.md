# Work Environment Jobs

```mermaid
flowchart TD
    A[WorkEnvironment::MorningJob] -->  B
    B[WorkEnvironment::DayJob] --> B
    B[WorkEnvironment::DayJob] --> C
    C[WorkEnvironment::SearchJob] --> D
    D[WorkEnvironment::ResultJob] --> E
    E[WorkEnvironment::DocumentJob] --> F
    F[WorkEnvironment::NotificationJob] --> G
    G[WorkEnvironment::EmailJob]
```