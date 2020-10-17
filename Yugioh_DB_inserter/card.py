import json
from db_connection import DbConnection
from mysql.connector import MySQLConnection, Error
import requests


class Card:
    def __init__(self):
        self.card_id = None
        self.name = None
        self.type = None
        self.level_rank = None
        self.attribute = None
        self.race = None
        self.attack = None
        self.defense = None
        self.pendulum_effect = None
        self.des_effect = None


class CardGateway:

    def get_all_cards(self):
        cards = []
        # url = "https://db.ygoprodeck.com/api/v7/cardinfo.php?id=39015"
        url = "https://db.ygoprodeck.com/api/v7/cardinfo.php"
        response = requests.get(url)
        cards_response = json.loads(response.content.decode())
        for card in cards_response["data"]:
            new_card = Card()
            new_card.card_id = card["id"]
            new_card.name = card["name"]
            new_card.type = card["type"]
            if card["type"] in ["Spell Card", "Trap Card", "Skill Card"]:
                pass
            elif card["type"] == "Link Monster":
                new_card.attribute = card["attribute"]
                new_card.attack = card["atk"]
            else:
                new_card.level_rank = card["level"]
                new_card.attribute = card["attribute"]
                new_card.attack = card["atk"]
                new_card.defense = card["def"]
                if card["type"] == "Pendulum Effect Monster":
                    desc = card['desc'].split("\r\n----------------------------------------\r\n")
                    if len(desc) > 1:
                        new_card.pendulum_effect = desc[0].strip("[ Pendulum Effect ]\r\n")
                        new_card.des_effect = desc[1].strip("[ Monster Effect ]\r\n")
                    else:
                        new_card.des_effect = card["desc"]
            new_card.race = card["race"]
            new_card.des_effect = card["desc"]
            cards.append(new_card)
        return cards

    def insert_card(self, card, username, pwd, schema):
        conn = DbConnection.get_connection(username, pwd, schema)
        cmd = conn.cursor()
        card_attributes = [card.card_id, card.name, card.type, card.level_rank, card.attribute, card.race, card.attack, card.defense,
                           card.pendulum_effect, card.des_effect]
        try:
            cmd.callproc("sp_insert_card", card_attributes)
            conn.commit()
        except Error as e:
            print(e)
        finally:
            cmd.close()
            conn.close()

    def get_all_card_ids(self, user, pwd, db):
        conn = DbConnection.get_connection(user, pwd, db)
        cmd = conn.cursor()
        try:
            cmd.execute("select card_id from card")
            card_ids = cmd.fetchall()
            cmd.close()
            conn.commit()
            return card_ids
        except Error as e:
            print(e)
        finally:
            cmd.close()
            conn.close()
