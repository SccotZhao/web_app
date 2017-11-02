from sqlalchemy import sql, orm
from app import db
from datetime import datetime

class People(db.Model):
    __tablename__ = 'people'
    name = db.Column('name', db.String(20), primary_key=True)
    house_or_senate = db.Column('house_or_senate', db.String(20))
    is_active = db.Column('is_active', db.Boolean())
    gender = db.Column('gender', db.String(20))
    state = db.Column('state', db.String(20))
    party = db.Column('party', db.String(20))
    since = db.Column('since', db.String(20))
    
    def __init__(self,name,gender):
       self.name = name
       self.gender = gender

class Committee(db.Model):
    __tablename__ = 'committee'
    sector_name = db.Column('sector_name', db.String(20), primary_key=True)
    house_or_senate = db.Column('house_or_senate', db.String(20))
    num_of_rep = db.Column('num_of_rep', db.Integer())
    num_of_dem = db.Column('num_of_dem', db.Integer())
    num_of_ind = db.Column('num_of_ind', db.Integer())


class Is_member_of(db.Model):
    __tablename__ = 'is_member_of'
    name = db.Column('name', db.String(20),primary_key=True)
    house_or_senate = db.Column('house_or_senate', db.String(20),
                     primary_key=True)
    is_chair = db.Column('is_chair', db.String(20))
    sector_name = db.Column('sector_name', db.String(20), primary_key=True)

class Bill(db.Model):
    __tablename__ = 'bill'
    bill_id = db.Column('bill_id', db.String(20),
                        primary_key=True)
    status = db.Column('status', db.String(20))
    title = db.Column('title', db.Text)
    introduction_date = db.Column('introduction_date', db.String(20))

class Is_sponsor_of(db.Model):
    __tablename__ = 'is_sponsor_of'
    name = db.Column('name', db.String(20),primary_key=True)
    bill_id = db.Column('bill_id', db.String(20),primary_key=True)
    is_primary_sponsor = db.Column('is_primary_sponsor', db.Boolean())

class Is_assigned_to(db.Model):
    __tablename__ = 'is_assigned_to'
    bill_id = db.Column('bill_id', db.String(20),primary_key=True)
    house_or_senate = db.Column('house_or_senate', db.String(20),
                     primary_key=True)
    sector_name = db.Column('sector_name', db.String(20), primary_key=True)

class Voted_bill (db.Model):
    __tablename__ = 'voted_bill'
    bill_id = db.Column('bill_id', db.String(20),primary_key=True)
    total_yes = db.Column('total_yes', db.Integer())
    total_no = db.Column('total_no', db.Integer())
    rep_yes = db.Column('rep_yes', db.Integer())
    rep_no = db.Column('rep_no', db.Integer())
    dem_yes = db.Column('dem_yes', db.Integer())
    dem_no = db.Column('dem_no', db.Integer())
    abstain = db.Column('abstain', db.Integer())
    date_of_vote = db.Column('date_of_vote', db.String(20))
    house_or_senate = db.Column('house_or_senate', db.String(20))

class Vote(db.Model):
    __tablename__ = 'vote'
    bill_id = db.Column('bill_id', db.String(20),primary_key=True)
    name = db.Column('name', db.String(50),
                    db.ForeignKey('people.name'),
                     primary_key=True)
    choice = db.Column('choice', db.String(20) )
