terraform/
│
├── backend/
│   ├── backend.tf
│   └── providers.tf
│
├── modules/
│   ├── resource-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── acr/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── aks/
│   │   ├── main.tf
│   │   ├── nodepool.tf
│   │   ├── identity.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── keyvault/
│   │   ├── main.tf
│   │   ├── secrets.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── postgres/
│   │   ├── main.tf
│   │   ├── firewall.tf
│   │   ├── database.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── storage/
│   │   ├── main.tf
│   │   ├── blob.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── servicebus/
│   │   ├── main.tf
│   │   ├── queue.tf
│   │   ├── topic.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── appgateway/
│   │   ├── main.tf
│   │   ├── waf.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── frontdoor/
│   │   ├── main.tf
│   │   ├── origin.tf
│   │   ├── routing.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── monitor/
│   │   ├── main.tf
│   │   ├── diagnostic.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── loganalytics/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── managed-identity/
│   │   ├── main.tf
│   │   ├── role-assignment.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── openai/
│       ├── main.tf
│       ├── model.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   │
│   ├── test/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   │
│   └── prod/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
│
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md