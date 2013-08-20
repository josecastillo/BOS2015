from flask import Flask
import flask_gzip
import ConfigParser

defaults = ConfigParser.ConfigParser()
defaults.readfp(open('artsfest.cfg'))

app = Flask(__name__, template_folder='views')
flask_gzip.Gzip(app)
app.config['SQLALCHEMY_DATABASE_URI'] = defaults.get('database', 'database_uri')
