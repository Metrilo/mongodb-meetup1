#!/usr/local/bin/python

import pymongo

client = pymongo.MongoClient("localhost", 27020)

db = client.mongodb_meetup1

print(db.name)
