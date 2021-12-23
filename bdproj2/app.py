import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
from flask import abort, render_template, Flask
import logging
import db

APP = Flask(__name__)

# Start page
@APP.route('/')
def index():
    stats = {}
    x = db.execute('SELECT COUNT(*) AS operators FROM OPERATOR').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS matchs FROM MATCH_R6').fetchone()
    stats.update(x)
    x = db.execute('SELECT COUNT(*) AS rounds FROM RD').fetchone()
    stats.update(x)
    logging.info(stats)
    return render_template('index.html',stats=stats)

# Operators
@APP.route('/operators/')
def list_operators():
        operators = db.execute(
            '''
            SELECT IdOper, OPERATOR.Name as Operator, Type, ORGANIZATION.Name as Organization
            FROM OPERATOR JOIN ORGANIZATION USING(IdOrg)
            ORDER BY OPERATOR.Name;
            ''').fetchall()
        return render_template('operator-list.html', operators=operators)
