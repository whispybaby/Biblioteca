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
            self.cursor.callproc("sp_plazo_extra", [id_prestamo])
        except:
            pass

    def sp_buscar_copia(self, id_libro):
        try:
            self.cursor.callproc("sp_buscar_copia", [id_libro])
        except:
            pass
    
    def sp_devolver_prestamo(self, id_prestamo):
        try:
            self.cursor.execute(f"call sp_devolver_prestamo({id_prestamo}))")
            resultado = self.cursor.fetchone()
            print(resultado)
        except:
            pass
    def sp_prestar_copia(self, id_copia, id_usuario):
        try:
            self.cursor.callproc("sp_prestar_copia", [id_copia, id_usuario])
        except:
            pass