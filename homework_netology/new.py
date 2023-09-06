import psycopg2



# Функция, создающая структуру БД (таблицы)
def create_db(cursor):
    cursor.execute('''
            CREATE TABLE IF NOT EXISTS client(
                client_id SERIAL PRIMARY KEY,
                first_name VARCHAR(50) NOT NULL,
                last_name VARCHAR(50),
                email VARCHAR(50) NOT NULL UNIQUE
            );
            CREATE TABLE IF NOT EXISTS phone(
            phone_id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES client(client_id),
            number VARCHAR(16) UNIQUE
            );
            ''')
    connect.commit()


# Функция, позволяющая добавить нового клиента.
def add_new_client(cursor,
                   first_name,
                   last_name,
                   email,
                   ):
    cursor.execute('''
                INSERT INTO client(first_name, last_name, email) VALUES (%s, %s, %s); 
            ''', (first_name, last_name, email))
    connect.commit()


# Функция, позволяющая добавить телефон для существующего клиента
def add_phone_from_client(cursor, client_id, number):
    cursor.execute('''
                INSERT INTO phone(client_id, number) VALUES (%s, %s);
            ''', (client_id, number))
    connect.commit()


# Функция, позволяющая изменить данные о клиенте.
def change_data_client(cursor, client_id, first_name=None, last_name=None, email=None, phone=None):
    if first_name!=None:
        cursor.execute('''
                    UPDATE client SET first_name=%s
                    WHERE client_id=%s ;
                ''', (first_name, client_id))
    connect.commit()
    if last_name!=None:
        cursor.execute('''
                    UPDATE client SET last_name=%s
                    WHERE client_id=%s ;
                ''', (last_name, client_id))
    connect.commit()
    if email!=None:
        cursor.execute('''
                    UPDATE client SET email=%s
                    WHERE client_id=%s ;
                ''', (email, client_id))
    connect.commit()
    if phone!=None:
        cursor.execute('''
                    UPDATE phone SET phone=%s
                    WHERE client_id=%s ;
                ''', (first_name, phone))
    connect.commit()


# Функция, позволяющая удалить телефон для существующего клиента.
def dell_phone_client(cursor, client_id, phone_id):
    cursor.execute('''
                DELETE FROM phone WHERE client_id=%s AND phone_id=%s; 
            ''', (client_id, phone_id))
    connect.commit()


# Функция, позволяющая удалить существующего клиента.
def dell_client(cursor, client_id):
    cursor.execute('''
                 DELETE FROM phone WHERE client_id=%s;
            ''', (client_id,))
    cursor.execute('''
                 DELETE FROM client WHERE client_id=%s;
                        ''', (client_id,))
    connect.commit()


# Функция, позволяющая найти клиента по его данным: имени, фамилии, email или телефону.
def find_client(cursor, first_name=None, last_name=None, email=None, phone=None):
    cursor.execute('''
                SELECT c.first_name, c.last_name FROM client c
                LEFT JOIN phone p ON c.client_id = p.client_id
                WHERE c.first_name=%s OR c.last_name=%s OR c.email=%s OR p.number=%s;
            ''', (first_name, last_name, email, phone))
    buff = cursor.fetchone()
    print(buff[0], buff[1])

try:
    connect = psycopg2.connect(
        dbname='netology_db',
        user='postgres',
        password='hargivfm2023@',
        host='localhost'
    )
    with connect.cursor() as cursor:
        cursor.execute('''
                DROP TABLE phone;
                DROP TABLE client;
                ''')

        create_db(cursor)

        add_new_client(cursor, 'Anna', 'None', 'anna@mail.ru')
        add_new_client(cursor, 'Bob', 'Bobinskii', 'bob@mail.ru')

        add_phone_from_client(cursor, 1, '8(925)-256-25-13')
        add_phone_from_client(cursor, 1, '8(925)-256-25-12')
        add_phone_from_client(cursor, 2, '8(900)-999-99-00')

        find_client(cursor, email='anna@mail.ru')
        find_client(cursor, phone='8(900)-999-99-00')

        change_data_client(cursor, client_id=1, first_name= 'Анна', last_name='Егорова')

        dell_phone_client(cursor, 1, 2)

        dell_client(cursor, 2)


except Exception as ex:
    print('[INFO Ошибка при подключении к PostgreSQL', ex)
finally:
    if connect:
        connect.close()
        print('[INFO] PostgreSQL дисконнект')
