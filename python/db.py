import pymysql
from sys import exit

def error(error):
    print(f"{error.args[0]}: {error.args[1]}")

class ConexionBD:
    def __init__(self, host, user, password, db) -> None:
        self.host = host
        self.user = user
        self.password = password
        self.db = db

    def conectar_bd(self) -> str:
        try:
            self.connection = pymysql.connect(
                host=self.host,
                user=self.user,
                passwd=self.password,
                db=self.db
            )
            self.cursor = self.connection.cursor()
            print("Conexión exitosa.")
        except pymysql.Error as e:
            error(e)
            print("Conexión fallida, inténtelo de nuevo.")
            exit(1)

    def sp_plazo_extra(self, id_prestamo):
        try:
            self.cursor.callproc("sp_plazo_extra")
        except:
            pass

    def sp_buscar_copia(self, id_libro):
        try:
            self.cursor.callproc("sp_buscar_copia")
        except:
            pass
    
    def sp_devolver_copia(self, id_copia, id_prestamo):
        try:
            self.cursor.callproc("sp_devolver_copia")
        except:
            pass
    def sp_prestar_copia(self, id_copia, id_usuario):
        try:
            self.cursor.callproc("sp_prestar_copia")
        except:
            pass