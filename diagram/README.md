## Diagram basecode for Take Away

````mermaid
erDiagram
    USERS ||--|| RESTAURANTS : "has"
    RESTAURANTS ||--o{ MENUS : "has"
    RESTAURANTS ||--o{ DISHES : "has"
    RESTAURANTS ||--o{ BEVERAGES : "has"
    RESTAURANTS ||--o{ SCHEDULES : "has"
    RESTAURANTS ||--o{ TAGS : "has"
    RESTAURANTS ||--o{ EMPLOYEES : "has"

    MENUS ||--o{ MENU_ITEMS : "has"
    MENU_ITEMS ||--o{ DISHES : "belongs to as menuable"
    MENU_ITEMS ||--o{ BEVERAGES : "belongs to as menuable"

    DISHES ||--o{ TAG_DISHES : "has"
    TAGS ||--o{ TAG_DISHES : "has"

    DISHES ||--o{ PORTIONS : "has as portionable"
    BEVERAGES ||--o{ PORTIONS : "has as portionable"

    MENUS ||--o{ ORDERS : "has"
    ORDERS ||--o{ ORDER_ITEMS : "has"
    PORTIONS ||--o{ ORDER_ITEMS : "belongs_to"
    PORTIONS ||--o{ PRICE_HISTORIES : "has"

    USERS {
        int id PK
        string email
        string encrypted_password
        string name
        string last_name
        string document_number
        int role
        datetime created_at
        datetime updated_at
    }

    EMPLOYEES {
        int id PK
        int restaurant_id FK
        string email
        string doc_number
        boolean registered
        datetime created_at
        datetime updated_at
    }

    RESTAURANTS {
        int id PK
        int user_id FK
        string brand_name
        string corporate_name
        string doc_number
        string address
        string phone
        string email
        string code
        datetime created_at
        datetime updated_at
    }

    MENUS {
        int id PK
        int restaurant_id FK
        string name
        datetime created_at
        datetime updated_at
        datetime discarded_at
    }

    DISHES {
        int id PK
        int restaurant_id FK
        string name
        text description
        int calories
        int status
        datetime created_at
        datetime updated_at
        datetime discarded_at
    }

    BEVERAGES {
        int id PK
        int restaurant_id FK
        string name
        string description
        boolean alcoholic
        int calories
        int status
        datetime created_at
        datetime updated_at
        datetime discarded_at
    }

    PORTIONS {
        int id PK
        string portionable_type
        int portionable_id
        string description
        int price
        datetime created_at
        datetime updated_at
        datetime discarded_at
    }

    MENU_ITEMS {
        int id PK
        int menu_id FK
        string menuable_type
        int menuable_id
        datetime created_at
        datetime updated_at
    }

    ORDERS {
        int id PK
        int menu_id FK
        string code
        string customer_name
        string customer_phone
        string customer_email
        string customer_doc
        string cancel_reason
        int status
        datetime created_at
        datetime updated_at
    }

    ORDER_ITEMS {
        int id PK
        int order_id FK
        int portion_id FK
        int quantity
        text note
        datetime created_at
        datetime updated_at
    }

    PRICE_HISTORIES {
        int id PK
        int portion_id FK
        int price
        datetime created_at
        datetime updated_at
    }

    SCHEDULES {
        int id PK
        int restaurant_id FK
        int week_day
        string open_time
        string close_time
        datetime created_at
        datetime updated_at
    }

    TAGS {
        int id PK
        int restaurant_id FK
        string name
        datetime created_at
        datetime updated_at
    }

    TAG_DISHES {
        int id PK
        int dish_id FK
        int tag_id FK
        datetime created_at
        datetime updated_at
    }
````