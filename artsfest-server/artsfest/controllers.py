from flask import render_template, jsonify
from artsfest import app
from artsfest.models import Event, Venue, Artist, Category, Sponsor
from random import choice
from flask import request
from datetime import datetime, timedelta, tzinfo
import calendar

ZERO = timedelta(0)
class UTC(tzinfo):
    """UTC"""
    def utcoffset(self, dt):
        return ZERO
    def tzname(self, dt):
        return "UTC"
    def dst(self, dt):
        return ZERO
utc = UTC()

cache = dict()
cache['artists'] = dict()
cache['venues'] = dict()
cache['events'] = dict()
cache['categories'] = dict()
cache['sponsors'] = dict()

def list_artists(format=None):
    updated_since = request.args.get('updated_since', 0)
    timestamp = datetime.fromtimestamp(int(updated_since), utc)
    artists = Artist.query.filter(Artist.last_modified > timestamp).all()
    response = jsonify(result=[artist.serialize() for artist in artists])
    return response
app.add_url_rule('/artists.<format>', 'list_artists', list_artists)

def list_venues(format=None):
    updated_since = request.args.get('updated_since', 0)
    timestamp = datetime.fromtimestamp(int(updated_since), utc)
    venues = Venue.query.filter(Venue.last_modified > timestamp).all()
    response = jsonify(result=[venue.serialize() for venue in venues])
    return response
app.add_url_rule('/venues.<format>', 'list_venues', list_venues)

def list_events(format=None):
    updated_since = request.args.get('updated_since', 0)
    timestamp = datetime.fromtimestamp(int(updated_since), utc)
    events = Event.query.filter(Event.last_modified > timestamp).all()
    response = jsonify(result=[event.serialize() for event in events])
    return response
app.add_url_rule('/events.<format>', 'list_events', list_events)

def list_categories(format=None):
    updated_since = request.args.get('updated_since', 0)
    timestamp = datetime.fromtimestamp(int(updated_since), utc)
    categories = Category.query.filter(Category.last_modified > timestamp).all()
    response = jsonify(result=[category.serialize() for category in categories])
    return response
app.add_url_rule('/categories.<format>', 'list_categories', list_categories)

def list_sponsors(format=None):
    updated_since = request.args.get('updated_since', 0)
    timestamp = datetime.fromtimestamp(int(updated_since), utc)
    sponsors = Sponsor.query.filter(Sponsor.last_modified > timestamp).all()
    response = jsonify(result=[sponsor.serialize() for sponsor in sponsors])
    return response
app.add_url_rule('/sponsors.<format>', 'list_sponsors', list_sponsors)

