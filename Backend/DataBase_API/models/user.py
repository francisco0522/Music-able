#!/usr/bin/python3
""" holds class User"""
import models
from models.base_model import BaseModel, Base
from os import getenv
import sqlalchemy
from sqlalchemy import Column, String
from sqlalchemy.orm import relationship


class User(BaseModel, Base):
    """Representation of a user """
    if models.storage_t == 'db':
        __tablename__ = 'users'
        email = Column(String(128), nullable=False)
        passwd = Column(String(128), nullable=False)
        full_name = Column(String(128), nullable=True)
    else:
        email = ""
        passwd = ""
        full_name = ""


    def __init__(self, *args, **kwargs):
        """initializes user"""
        super().__init__(*args, **kwargs)
