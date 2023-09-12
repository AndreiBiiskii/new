import sqlalchemy
from sqlalchemy.orm import sessionmaker
from models import *

DSN = 'postgresql://postgres:Be098140a513@localhost:5432/netology_db'

engine = sqlalchemy.create_engine(DSN)
create_tables(engine)
Session = sessionmaker(bind=engine)
session = Session()

publisher1 = Publisher(name='Лев Толстой')
publisher2 = Publisher(name='Атлас. ФГОС')
publisher3 = Publisher(name='Марк Леви')
session.add_all([publisher3, publisher2, publisher1])
session.commit()

book1 = Book(title='Война и мир том 1', publisher=publisher1)
book2 = Book(title='География. 9 класс', publisher=publisher2)
book3 = Book(title='Кибератаки, шпионы и саспенс', publisher=publisher3)
book4 = Book(title='География. 6 класс', publisher=publisher2)
book5 = Book(title='География. 7 класс', publisher=publisher2)
book6 = Book(title='География. 10 класс', publisher=publisher2)
session.add_all([book1, book2, book3, book4, book5, book6])
session.commit()

shop1 = Shop(name='Москва')
shop2 = Shop(name='Иркутск')
shop3 = Shop(name='Братск')
session.add_all([shop3, shop2, shop1])
session.commit()

stock1 = Stock(book=book1, shop=shop1, count=25)
stock2 = Stock(book=book3, shop=shop2, count=13)
stock3 = Stock(book=book3, shop=shop3, count=2)
stock4 = Stock(book=book4, shop=shop2, count=25)
stock5 = Stock(book=book5, shop=shop2, count=13)
stock6 = Stock(book=book6, shop=shop3, count=2)
session.add_all([stock1, stock3, stock2, stock4, stock5, stock6])
session.commit()

sale1 = Sale(price=150.40, date_sale='2023-05-12', stock=stock1, count=150)
sale2 = Sale(price=1200.00, date_sale='2022-07-18', stock=stock2, count=200)
sale3 = Sale(price=500.50, date_sale='2022-09-04', stock=stock3, count=130)
sale4 = Sale(price=620.50, date_sale='2022-09-04', stock=stock4, count=120)
sale5 = Sale(price=700.50, date_sale='2022-09-04', stock=stock5, count=13)
sale6 = Sale(price=605.50, date_sale='2022-09-04', stock=stock6, count=10)
session.add_all([sale3, sale2, sale1, sale6, sale5, sale4])
session.commit()

# *** Авторы *** -->> 'Лев Толстой', 'Атлас. ФГОС', 'Марк Леви')
name = input()

query = session.query(Book)
query = query.join(Publisher).filter(Publisher.name.like(f'%{name}%'))
query = query.join(Stock, Book.id ==  Stock.id_book)
query = query.join(Shop, Stock.id_shop == Shop.id)
query = query.join(Sale, Sale.id_stock == Stock.id)
# print(query)
for i in query.all():
    for j in i.stocks:
        print(i.title, end=' | ')
        print(j.shop.name, end=' | ')
        for k in j.sales:
            print(k.price, ' | ', k.date_sale)


session.close()

