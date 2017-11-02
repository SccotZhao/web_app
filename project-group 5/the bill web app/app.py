from flask import Flask, render_template, redirect, url_for,session,request
from flask_sqlalchemy import SQLAlchemy
from models import *
#import forms
import psycopg2

app = Flask(__name__)
app.secret_key = 's3cr3t'
app.config.from_object('config')
db = SQLAlchemy(app, session_options={'autocommit': False})


@app.route('/')
def home():
    return render_template('index.html')

@app.route('/bill')
def bill():
    return render_template('Bills.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/politician')
def politician():
    return render_template('politician.html')

@app.route('/sponsor')
def sponsor():
    return render_template('Relation.html')


@app.route('/all-people')
def all_people():
    people= db.session.query(models.People).all()
    return render_template('all-people.html', people=people)

@app.route('/signup', methods=['GET','POST'])
def signup():
    people = People(request.form['name'], request.form['gender'])
    
    if (db.session.query(People.name).filter_by(name = request.form['name'] , gender = request.form['gender']).scalar() is not None):
        return redirect(url_for('message', name=people.name, gender = people.gender))
    return redirect(url_for('no_message'))

@app.route('/search-bill', methods=['GET','POST'])
def search_bill():
    text = request.form.get("Search Bill")
    return redirect(url_for('message_bill', text = text[0]))



@app.route('/message/<name>/<gender>', methods=['GET','POST'])
def message(name,gender):  
  people = People.query.filter_by(name = name, gender = gender).first_or_404()
  return render_template('message.html', name = people.name, party = people.party, gender = people.gender, since = people.since, is_active = people.is_active)


@app.route('/no-message', methods=['GET','POST'])
def no_message():
    return render_template('no-message.html')



#Top 5 Sectors with most INTRODUCED Bills
def test1_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute('SELECT sector_name, count(*) as count FROM Bill, is_Assigned_To WHERE Bill.bill_id = is_Assigned_To.bill_id GROUP BY sector_name  ORDER BY count(sector_name)  DESC LIMIT 5')
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list


#Top 5 Sectors with PASSED Bills
def test2_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT sector_name , count(*) as count FROM Bill, is_Assigned_To WHERE Bill.bill_id = is_Assigned_To.bill_id AND Bill.status LIKE '%Enacted%' OR Bill.status LIKE '%SIgned By President%' GROUP BY sector_name ORDER BY count(sector_name)  DESC LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list


#Top 5 Sectors With Most Failed Bills
#But it seems there no failed bill in our database
def test3_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT sector_name, count(*) as count FROM Bill, is_Assigned_To WHERE Bill.bill_id = is_Assigned_To.bill_id AND Bill.status LIKE '%Enacted%' OR Bill.status LIKE '%SIgned By President%' GROUP BY sector_name ORDER BY count(sector_name)  DESC LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#Top 5 Sectors With Least Passed Bills
def test4_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT sector_name, count(*) as count FROM Bill, is_Assigned_To WHERE Bill.bill_id = is_Assigned_To.bill_id AND Bill.status LIKE '%Enacted%' OR Bill.status LIKE '%SIgned By President%' GROUP BY sector_name  ORDER BY count(sector_name) LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#Sectors With Bills That Get Roll Call Votes
#need to write
def test5_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT committee.sector_name, count(*) as count FROM voted_bill, is_assigned_to, committee WHERE voted_bill.bill_id=is_assigned_to.bill_id  AND committee.sector_name = is_assigned_to.sector_name GROUP BY committee.sector_name ORDER BY count(*) DESC")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#Top 5 Sectors of Bills Introduced By Democrats
def test4_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT sector_name, count(*) as count FROM Bill, is_Assigned_To WHERE Bill.bill_id = is_Assigned_To.bill_id AND Bill.status LIKE '%Enacted%' OR Bill.status LIKE '%SIgned By President%' GROUP BY sector_name  ORDER BY count(sector_name) LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list


#Top 5 Sectors of Bills Introduced By Democrats
def test6_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT A.HOUSE_OR_SENATE, A.SECTOR_NAME, COUNT(*) AS C FROM IS_SPONSOR_OF S, PEOPLE P, IS_ASSIGNED_TO A WHERE S.BILL_ID=A.BILL_ID AND S.NAME=P.NAME AND P.PARTY='Democrat' AND S.IS_PRIMARY_SPONSOR=TRUE GROUP BY A.HOUSE_OR_SENATE, A.SECTOR_NAME ORDER BY C DESC LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#Top 5 Sectors of Bills Introduced By Republicans
def test7_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT A.HOUSE_OR_SENATE, A.SECTOR_NAME, COUNT(*) AS C FROM IS_SPONSOR_OF S, PEOPLE P, IS_ASSIGNED_TO A WHERE S.BILL_ID=A.BILL_ID AND S.NAME=P.NAME AND P.PARTY='Republican' AND S.IS_PRIMARY_SPONSOR=TRUE GROUP BY A.HOUSE_OR_SENATE, A.SECTOR_NAME ORDER BY C DESC LIMIT 5")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#number of bills in different status
def test8_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT STATUS, COUNT(*) as count FROM BILL GROUP BY STATUS;")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list

#monthly bill introduction by dep/rep
def test9_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT RIGHT(B.INTRODUCTION_DATE,4) AS Y,LEFT(B.INTRODUCTION_DATE,3) AS M, COUNT(CASE WHEN P.PARTY='dem' THEN 1 ELSE 0 END) AS NUM_DEM, COUNT(CASE WHEN P.PARTY='rep' THEN 1 ELSE 0 END) AS NUM_REP FROM BILL B, IS_SPONSOR_OF S, PEOPLE P WHERE B.BILL_ID=S.BILL_ID AND S.NAME=P.NAME AND S.IS_PRIMARY_SPONSOR=TRUE GROUP BY Y,M ORDER BY Y,M; ")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list



#number of dem/rep in committee
def testa_for_bill():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT M.HOUSE_OR_SENATE,M.SECTOR_NAME, SUM(CASE WHEN P.PARTY='Democrat' THEN 1 ELSE 0 END) AS NUM_DEM, SUM(CASE WHEN P.PARTY='Republican' THEN 1 ELSE 0 END) AS NUM_REP,COUNT(*) FROM IS_MEMBER_OF M,PEOPLE P  WHERE M.NAME=P.NAME GROUP BY M.HOUSE_OR_SENATE, M.SECTOR_NAME ORDER BY M.HOUSE_OR_SENATE, M.SECTOR_NAME;")
    list = []
    for sector_name in cur:
       list.append(sector_name)
    cur.close()
    conn.close()
    return list



@app.route('/message-bill/<text>', methods=['GET','POST'])
def message_bill(text):
    if text == "1":
        list = test1_for_bill()
        return render_template('message-bill.html', list= list)
    elif  text == "2":
        list = test2_for_bill()
        return render_template('message-bill.html', list= list) 
    elif  text == "3":
        list = test3_for_bill()
        return render_template('message-bill.html', list= list)
    elif  text == "4":
        list = test4_for_bill()
        return render_template('message-bill.html', list= list)
    elif  text == "5":
        list = test5_for_bill()
        return render_template('message-bill.html', list= list) 
    elif  text == "6":
        list = test6_for_bill()
        return render_template('message-bill.html', list= list) 
    elif  text == "7":
        list = test7_for_bill()
        return render_template('message-bill.html', list= list) 
    elif  text == "8":
        list = test8_for_bill()
        return render_template('message-bill.html', list= list) 
    elif  text == "9":
        list = test9_for_bill()
        return render_template('message-bill.html', list= list)  
    elif  text == "a":
        list = testa_for_bill()
        return render_template('message-bill.html', list= list) 
    return redirect(url_for('no_message_bill'))


@app.route('/no-message-bill', methods=['GET','POST'])
def no_message_bill():
    return render_template('no-message-bill.html')   





@app.route('/people/<name>')
def people(name):   
    people=db.session.query(models.People)\
         .filter(models.People.name == name).one()
    return render_template('people.html',people=people)



@app.route('/search-people', methods=['GET','POST'])
def search_people():
    text = request.form.get("Search People")
    return redirect(url_for('message_people', text = text[0]))



#Chairs of some 10 random committes
def people1():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT M.NAME,M.HOUSE_OR_SENATE,M.SECTOR_NAME,P.PARTY FROM IS_MEMBER_OF M,PEOPLE P WHERE M.IS_CHAIR='Chairman' AND M.NAME=P.NAME LIMIT 10;")
    list = []
    for name in cur:
        list.append(name )
    cur.close()
    conn.close()
    return list


#votes least number of times
def people2():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT Vote.name, People.party, People.state, count(*) as count FROM VOTE, PEOPLE WHERE choice = 'Not Voting' AND VOTE.name = PEOPLE.name GROUP BY vote.name, People.party, People.state ORDER BY count(choice) LIMIT  10;")  
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list

#list person who vote most yes for bills sponsored by the other party
def people3():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute("SELECT V.NAME, COUNT(*) FROM VOTE V, IS_SPONSOR_OF S, PEOPLE P1, PEOPLE P2 WHERE V.CHOICE='Aye' AND V.BILL_ID=S.BILL_ID AND S.NAME=P2.NAME AND S.IS_PRIMARY_SPONSOR=TRUE AND V.NAME=P1.NAME AND P1.PARTY<>P2.PARTY GROUP BY V.NAME ORDER BY V.NAME;")
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list


#top 10 sponsors of most bills
def people4():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute('SELECT name, COUNT(*) as count FROM IS_SPONSOR_OF GROUP BY name ORDER BY count DESC LIMIT 10 ;')
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list
 


@app.route('/message-people/<text>', methods= ['GET','POST'])
def message_people(text):
    if  text == "1":
        list = people1()
        return render_template('message-people.html', list= list) 
    elif  text == "2":
        list = people2()
        return render_template('message-people.html', list= list)
    elif  text == "3":
        list = people3()
        return render_template('message-people.html', list= list) 
    elif  text == "4":
        list = people4()
        return render_template('message-people.html', list= list)   
    return redirect(url_for('no_message_people'))






@app.route('/no-message-people', methods=['GET','POST'])
def no_message_people():
    return render_template('no-message-people.html')   




@app.route('/search-overview', methods=['GET','POST'])
def search_overview():
    text = request.form.get("Search Overview")
    return redirect(url_for('message_overview', text = text[0]))

@app.route('/message-overview/<text>', methods= ['GET','POST'])
def message_overview(text):
    if  text == "1":
        list = overview1()
        return render_template('message-overview.html', list= list) 
    elif  text == "2":
        list = overview2()
        return render_template('message-overview.html', list= list)
    elif  text == "3":
        list = overview3()
        return render_template('message-overview.html', list= list) 
    return redirect(url_for('no_message_overview'))

#bill by sector
def overview1():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute('SELECT A.HOUSE_OR_SENATE, A.SECTOR_NAME, COUNT(*) FROM IS_ASSIGNED_TO A GROUP BY A.HOUSE_OR_SENATE, A.SECTOR_NAME ORDER BY A.HOUSE_OR_SENATE, A.SECTOR_NAME;')
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list

#bill by party sponsorship
def overview2():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute('SELECT P.PARTY, COUNT(*) FROM IS_SPONSOR_OF S, PEOPLE P WHERE S.IS_PRIMARY_SPONSOR=TRUE AND S.NAME=P.NAME GROUP BY P.PARTY;')
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list

#bill introduction by house or senate
def overview3():
    conn = psycopg2.connect(dbname='bills')
    cur = conn.cursor()
    cur.execute('SELECT P.HOUSE_OR_SENATE, COUNT(*) FROM IS_SPONSOR_OF S, PEOPLE P WHERE S.IS_PRIMARY_SPONSOR=TRUE AND S.NAME=P.NAME GROUP BY P.HOUSE_OR_SENATE;')
    list = []
    for name in cur:
        list.append(name)
    cur.close()
    conn.close()
    return list




@app.route('/no-message-overview', methods=['GET','POST'])
def no_message_overview():
    return render_template('no-message-overview.html') 








if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
