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


""" # Rounds
@APP.route('/rounds/')
def list_rounds():
        rounds = db.execute(
            '''
            SELECT RD.IdMatch AS Match_Id, RD.IdRound AS Round_Id, RD.RoundWinner AS Round_Winner, OP.Name AS Operator, S.K AS Kills, S.D AS Deaths, S.A AS Assists
            FROM RD, OPERATOR OP, SELECTED S
            WHERE OP.IdOper = S.IdOper AND S.IdRound = RD.IdRound;
            ''').fetchall()
            
        return render_template('round-list.html', rounds=rounds) """

# Rounds
@APP.route('/rounds/')
def list_rounds():
        rounds = db.execute(
            '''
            SELECT RD.IdMatch AS Match_Id, RD.IdRound AS Round_Id, RD.RoundWinner AS Round_Winner
            FROM RD;
            ''').fetchall()
            
        return render_template('round-list.html', rounds=rounds)