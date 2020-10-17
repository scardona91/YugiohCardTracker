import requests
from mysql.connector import MySQLConnection, Error

from db_connection import DbConnection

BASE_URL = "https://storage.googleapis.com/ygoprodeck.com/"


class CardImg:
    def __init__(self):
        self.card_id = None
        self.bg_image = None
        self.sm_image = None


class CardImageGateway:
    def get_large_image(self, card_id):
        endpoint = f"pics/{card_id[0]}.jpg"
        url = f"{BASE_URL}{endpoint}"
        response = requests.get(url)
        image_bytes = response.content.decode("UTF-8", "ignore")
        image = image_bytes.encode("UTF-8", "ignore")
        return image

    def get_small_image(self, card_id):
        endpoint = f"pics_small/{card_id[0]}.jpg"
        url = f"{BASE_URL}{endpoint}"
        response = requests.get(url)
        image_bytes = response.content.decode("UTF-8", "ignore")
        image = image_bytes.encode("UTF-8", "ignore")
        return image

    def insert_card_img(self, card_id, bg_image, sm_image, user, pwd, db):
        conn = DbConnection.get_connection(user, pwd, db)
        cmd = conn.cursor()
        params = [int(card_id[0]), bg_image, sm_image]
        try:
            cmd.callproc("sp_insert_card_img", params)
            conn.commit()
        except Error as e:
            print(e)
        finally:
            cmd.close()
            conn.close()
