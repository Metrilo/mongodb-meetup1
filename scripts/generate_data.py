#!/usr/local/bin/python

import pymongo
from faker import Factory
import random
import threading
import time
import sys

if len(sys.argv) < 2:
    raise Exception("At least two arguments must be passed! DB host and port")

MONGODB_HOSTNAME = sys.argv[1]
MONGODB_PORT = int(sys.argv[2])

# Single insert batch size
GENERATOR_BATCH_SIZE = 500
# Number of batch insertion rounds
GENERATOR_BATCH_ROUNDS = 20

# In N threads
GENERATOR_THREADS = 5

# Event distributed by shop_id
SHOP_ID_DISTRIBUTION = [1, 2, 3, 4, 5, 6]
# Or some different distribution
# SHOP_ID_DISTRIBUTION = [1, 1, 1, 1, 1, 2, 3, 4, 5, 6]

def mongodb_client():
    return pymongo.MongoClient(MONGODB_HOSTNAME, MONGODB_PORT)

def generate_random_customer(fake):
    return {
        'shop_id': random.choice(SHOP_ID_DISTRIBUTION),
        'name': fake.name(),
        'address': fake.address(),
        'company': fake.company(),
        'phone_number': fake.phone_number(),
        'first_order_at': fake.date_time_this_decade()
    }

def generate_full_round():
    fake = Factory.create()
    db = mongodb_client().mongodb_meetup1

    for round_index in range(GENERATOR_BATCH_ROUNDS):
        bulk_documents = []

        for _ in range(GENERATOR_BATCH_SIZE):
            bulk_documents.append(generate_random_customer(fake))

        db.customers.insert_many(bulk_documents, ordered=False, bypass_document_validation=True)

threads = []
for thread_index in range(GENERATOR_THREADS):
    t = threading.Thread(target=generate_full_round)
    threads.append(t)
    t.start()
