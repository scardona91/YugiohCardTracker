import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed

from tqdm import tqdm
import sys
from card import CardGateway
from card_img import CardImageGateway

parser = argparse.ArgumentParser()
parser.add_argument("--username")
parser.add_argument("--db")
parser.add_argument("--password")


def main():
    args = parser.parse_args()
    username = args.username
    password = args.password
    schema = args.db
    print("\n\nStarted Writing to DB\n")

    print('Writing cards to card table...')
    with ThreadPoolExecutor(max_workers=100) as executor:
        cards = CardGateway().get_all_cards()
        results = [executor.submit(CardGateway().insert_card, card, username, password, schema) for card in cards]

        for _ in tqdm(as_completed(results), total=len(cards), unit=" cards", smoothing=True):
            pass

    print('Finished writing to card table!\n')

    print("Writing Images to card_img table...")

    with ThreadPoolExecutor(max_workers=100) as executor:
        card_ids = CardGateway().get_all_card_ids(username, password, schema)
        results = [
            executor.submit(CardImageGateway().insert_card_img, card_id, CardImageGateway().get_large_image(card_id),
                            CardImageGateway().get_small_image(card_id), username, password, schema) for card_id
            in card_ids]

        for _ in tqdm(as_completed(results), total=len(card_ids), unit=" cards", smoothing=True):
            pass

    print('Finished writing to card_img table.')

    print("End Program")
    return 0


sys.exit(main())
