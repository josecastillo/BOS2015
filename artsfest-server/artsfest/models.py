import sqlalchemy
from flask.ext.sqlalchemy import SQLAlchemy
from urllib import urlencode
from artsfest import app
import calendar

db = SQLAlchemy(app)

class Artist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200))

    active = db.Column(db.Boolean, default=True)
    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))
    
    def serialize(self):
        return {'id' : self.id, 'name' : self.name, 'active' : self.active, 'last_modified' : calendar.timegm(self.last_modified.utctimetuple())}

class Venue(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200))
    address = db.Column(db.String(200))
    city = db.Column(db.String(50))
    state = db.Column(db.String(2))
    country = db.Column(db.String(50))
    zip = db.Column(db.String(10))
    lat = db.Column(db.Float)
    lon = db.Column(db.Float)
    map_identifier = db.Column(db.String(5))
    
    active = db.Column(db.Boolean, default=True)
    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))
    
    def map_embed_url(self):
        params = dict()
        params['t'] = 'm'
        params['z'] = '14'
        params['q'] = 'loc:' + self.address + ' ' + self.city + ' ' + self.state + ' ' + self.zip + '@' + str(self.lat) + ',' + str(self.lon)
        params['iwloc'] = 'near'
        params['output'] = 'embed'
        
        return 'https://maps.google.com/maps?' + urlencode(params)
    
    def serialize(self):
        return {'id' : self.id, 'name' : self.name, 'address' : self.address, 'city' : self.city, 'state' : self.state, 'country' : self.country, 'zip' : self.zip, 'lat' : self.lat, 'lon' : self.lon, 'map_identifier' : self.map_identifier, 'address' : self.address, 'active' : self.active, 'last_modified' : calendar.timegm(self.last_modified.utctimetuple())}
    
event_artists = db.Table('event_artists', db.Column('event_id', db.Integer, db.ForeignKey('event.id')), db.Column('artist_id', db.Integer, db.ForeignKey('artist.id')))
event_categories = db.Table('event_categories', db.Column('event_id', db.Integer, db.ForeignKey('event.id')), db.Column('category_id', db.Integer, db.ForeignKey('category.id')))

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200))
    short_desc = db.Column(db.Text)
    long_desc = db.Column(db.Text)
    section = db.Column(db.String(100))
    room = db.Column(db.String(100))
    venue_id = db.Column(db.Integer, db.ForeignKey('venue.id'))
    venue = db.relationship('Venue', backref=db.backref('events', lazy='dynamic', order_by="Event.name"))
    artists = db.relationship('Artist', secondary=event_artists, backref=db.backref('events', lazy='dynamic'), order_by="Artist.name")
    categories = db.relationship('Category', secondary=event_categories, backref=db.backref('events', lazy='dynamic'), order_by="Category.order")
    times = db.relationship('EventHours')

    active = db.Column(db.Boolean, default=True)
    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))

    def serialize(self):
        return {'id' : self.id, 'name' : self.name, 'short_desc' : self.short_desc, 'long_desc' : self.long_desc, 'section' : self.section, 'room' : self.room, 'venue' : self.venue_id, 'artists' : [artist.id for artist in self.artists], 'categories' : [category.id for category in self.categories], 'hours' : [time.serialize() for time in self.times], 'active' : self.active, 'last_modified' : calendar.timegm(self.last_modified.utctimetuple())}

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200))
    group = db.Column(db.String(200))
    order = db.Column(db.Integer)

    active = db.Column(db.Boolean, default=True)
    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))

    def serialize(self):
        return {'id' : self.id, 'name' : self.name, 'group' : self.group, 'order' : self.order, 'active' : self.active, 'last_modified' : calendar.timegm(self.last_modified.utctimetuple())}


class EventHours(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    event_id = db.Column(db.Integer, db.ForeignKey('event.id'))
    opens = db.Column(db.DateTime)
    closes = db.Column(db.DateTime)
    notes = db.Column(db.String(200))

    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))

    def serialize(self):
        return {'opens' : calendar.timegm(self.opens.utctimetuple()), 'closes' : calendar.timegm(self.closes.utctimetuple()) if self.closes else None, 'notes' : self.notes}

class Sponsor(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200))
    short_desc = db.Column(db.Text)
    website = db.Column(db.String(200))
    sponsor_level = db.Column(db.String(100))

    active = db.Column(db.Boolean, default=True)
    last_modified = db.Column(db.DateTime, db.ColumnDefault(sqlalchemy.func.now(), for_update=True), server_default=db.DefaultClause(sqlalchemy.func.now()))

    def serialize(self):
        return {'id' : self.id, 'name' : self.name, 'short_desc' : self.short_desc, 'website' : self.website, 'sponsor_level' : self.sponsor_level, 'active' : self.active, 'last_modified' : calendar.timegm(self.last_modified.utctimetuple())}
