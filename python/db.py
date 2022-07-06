from subprocess import CalledProcessError, call
from colorama import Cursor
import pymysql
from sys import exit


def error(error):
    print(f"{error.args[0]}: {error.args[1]}")


class ConexionBD:
    def __init__(self, host, user, password, db):
        self.host = host
        self.user = user
        self.password = password
        self.db = db

    def conectar_bd(self):
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
            self.cursor.callproc(
                "sp_plazo_extra",[id_prestamo])
            resultado = self.cursor.fetchone()

            input(f"\n{resultado[0]}")

        except:
            pass

    def sp_buscar_copia(self, id_libro):
        try:
            self.cursor.callproc(
                "sp_buscar_copia", [id_libro])
            resultado = self.cursor.fetchone()
            input(f"\n{resultado[0]}")
        except:
            pass

    def sp_devolver_prestamo(self, id_prestamo):
        try:
            self.cursor.callproc(
                "sp_devolver_prestamo" , [id_prestamo])
            resultado = self.cursor.fetchone()
            
            input(f"\n{resultado[0]}")
        except:
            pass

    def sp_prestar_copia(self, id_copia, id_usuario):
        try:
            self.cursor.callproc(
                "sp_prestar_copia", [id_copia, id_usuario])
            resultado = self.cursor.fetchone()

            input(f"\n{resultado[0]}")
        except:
            pass
    
    def sp_pagar_multa(self, id_prestamo, monto_abono):
        try:
            self.cursor.callproc(
                "sp_pagar_multa", [id_prestamo, monto_abono])
            resultado = self.cursor.fetchone()

            input(f"\n{resultado[0]}")
        except:
            pass
