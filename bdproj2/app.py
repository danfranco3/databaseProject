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
    x = db.execute('SELECT COUNT(*) AS matches FROM MATCH_R6').fetchone()
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
            ORDER BY OPERATOR.Name
            ''').fetchall()
        return render_template('operator-list.html', operators=operators)

# Rounds
@APP.route('/rounds/')
def list_rounds():
        rounds = db.execute(
            '''
            SELECT RD.IdMatch AS Match_Id, RD.IdRound AS Round_Id, RD.RoundWinner AS Round_Winner
            FROM RD
            ''').fetchall()
        return render_template('round-list.html', rounds=rounds)

#Matchs
@APP.route('/matches/')
def list_match():
    matches = db.execute(
        '''
        SELECT IdMatch, Start, End, Status, IdMap, Name
        FROM MATCH_R6 NATURAL JOIN MAP   
        ''').fetchall()
    return render_template('match-list.html', matches=matches)

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



@APP.route('/operators/<int:id>/')
def get_operator(id):
    operator = db.execute(
    '''
    SELECT IdOper, Name as Operator, Type, Device
    FROM OPERATOR 
    WHERE IdOper = %s
    ''', id).fetchone()

    if operator is None:
        abort(404, 'Operator id {} does not exist'.format(id))
    
    organization = db.execute(
    '''    
    SELECT IdOrg, ORGANIZATION.Name 
    FROM ORGANIZATION JOIN OPERATOR USING(IdOrg)
    WHERE IdOper = %s
    ''',id).fetchone()

    gadget = db.execute(
    '''    
    SELECT IdGad, GADGET.Name 
    FROM GADGET JOIN OPERATOR USING(IdGad)
    WHERE IdOper = %s
    ''',id).fetchall()

    weapon = db.execute(
    '''    
    SELECT IdOrg, WEAPON.Name 
    FROM WEAPON JOIN OPERATOR USING(IdWp)
    WHERE IdOper = %s
    ''',id).fetchall()

    selected = db.execute(
    '''    
    SELECT IdOper,IdRound
    FROM SELECTED NATURAL JOIN OPERATOR 
    WHERE IdOper = %s
    ''',id).fetchall()
    return render_template('operator.html',
        operator=operator, organization=organization, gadget=gadget, weapon=weapon, selected=selected)

@APP.route('/rounds/<int:id>/')
def get_round(id):
    round = db.execute(
    '''  
    SELECT IdRound, RoundWinner, IdMatch
    FROM RD WHERE IdRound = %s
    ''', id).fetchone()

    selected = db.execute(
    '''
    SELECT IdRound, K, D, A, IdOper, Name, Type
    FROM RD NATURAL JOIN SELECTED NATURAL JOIN OPERATOR
    WHERE IdRound = %s 
    ''', id).fetchall()

    return render_template('round.html', round=round, selected=selected)

@APP.route('/matches/<int:id>/')
def get_match(id):
    match = db.execute(
        '''
        SELECT IdMatch, Start, End, Status, MVP, MVPPOINTS, MAP.Name as Map, IdOper
        FROM MATCH_R6 NATURAL JOIN MAP, OPERATOR
        WHERE IdMatch = %s AND OPERATOR.Name = MVP
        ''', id).fetchone()
    rounds = db.execute(
        '''
        SELECT IdRound, RoundWinner
        FROM RD
        WHERE IdMatch = %s
        ''', id).fetchall()
    return render_template('match.html', match=match, rounds=rounds)

@APP.route('/operators/search/<expr>/')
def search_operator(expr):
    search = { 'expr': expr }
    expr = '%' + expr + '%'
    operators = db.execute(
        '''
        SELECT IdOper, Name 
        FROM OPERATOR
        WHERE Name LIKE %s
        ''', expr).fetchall()
    return render_template('operator-search.html', search=search, operators=operators)


@APP.route('/operators/details/')
def get_operators():
    operators = db.execute(
        '''
        SELECT IdWp, IdOper, O.Name AS Operator, O.Type, Device, 
        ORGANIZATION.Name AS Org, GADGET.Name AS Gadget, WEAPON.Name AS Weapon
        FROM OPERATOR O
        JOIN ORGANIZATION USING(IdOrg) 
        JOIN GADGET USING(IdGad)
        JOIN WEAPON USING(IdWp)
        ''').fetchall()
    return render_template('operators-list-details.html', operators=operators)