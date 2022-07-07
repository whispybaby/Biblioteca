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
        except pymysql.Error as e:
            error(e)
            print("Conexión fallida, inténtelo de nuevo.")
            exit(1)

    def guardar_cambios(self):
        try:
            self.connection.commit()
            print('Cambios guardados.')
        except:
            pass

    def sp_plazo_extra(self, id_prestamo):
        try:
            self.cursor.callproc(
                "sp_plazo_extra", [id_prestamo])
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
                "sp_devolver_prestamo", [id_prestamo])
            resultado = self.cursor.fetchone()

            input(f"\n{resultado[0]}")
        except:
            pass

    def sp_realizar_prestamo(self, id_copia, id_usuario):
        try:
            self.cursor.callproc(
                "sp_realizar_prestamo", [id_copia, id_usuario])
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

    def listar_usuarios(self):
        try:
            consulta = 'SELECT * FROM usuario;'
            self.cursor.execute(consulta)
            usuarios = self.cursor.fetchall()
            for usuario in usuarios:
                print(f'\nId usuario:      {usuario[0]}')
                print(f'Nombre:          {usuario[1]}')
                print(f'Apellido:        {usuario[2]}')
                print(f'Id tipo usuario: {usuario[3]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_prestamos(self):
        try:
            consulta = 'SELECT * FROM prestamo;'
            self.cursor.execute(consulta)
            prestamos = self.cursor.fetchall()
            for prestamo in prestamos:
                print(f'\nId préstamo:    {prestamo[0]}')
                print(f'Id copia:       {prestamo[1]}')
                print(f'Id usuario:     {prestamo[2]}')
                print(f'Id multa:       {prestamo[3]}')
                print(f'Id plazo extra: {prestamo[4]}')
                print(f'Fecha préstamo: {prestamo[5]}')
                print(f'Fecha entrega:  {prestamo[6]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_autores(self):
        try:
            consulta = 'SELECT * FROM autor;'
            self.cursor.execute(consulta)
            autores = self.cursor.fetchall()
            for autor in autores:
                print(f'\nId autor:            {autor[0]}')
                print(f'Nombre:              {autor[1]}')
                print(f'Apellido:            {autor[2]}')
                print(f'Fecha de nacimiento: {autor[3]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_estados(self):
        try:
            consulta = 'SELECT * FROM estado;'
            self.cursor.execute(consulta)
            estados = self.cursor.fetchall()
            for estado in estados:
                print(f'\nId estado: {estado[0]}')
                print(f'Nombre:    {estado[1]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_libros(self):
        try:
            consulta = 'SELECT * FROM libro;'
            self.cursor.execute(consulta)
            libros = self.cursor.fetchall()
            for libro in libros:
                print(f'\nId libro:             {libro[0]}')
                print(f'Id editorial:         {libro[1]}')
                print(f'Título:               {libro[2]}')
                print(f'Fecha de publicación: {libro[3]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_editoriales(self):
        try:
            consulta = 'SELECT * FROM editorial;'
            self.cursor.execute(consulta)
            editoriales = self.cursor.fetchall()
            for editorial in editoriales:
                print(f'\nId editorial:       {editorial[0]}')
                print(f'Nombre:             {editorial[1]}')
                print(f'Correo:             {editorial[2]}')
                print(f'Teléfono:           {editorial[3]}')
                print(f'Fecha de fundación: {editorial[4]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_categorias(self):
        try:
            consulta = 'SELECT * FROM categoria;'
            self.cursor.execute(consulta)
            categorias = self.cursor.fetchall()
            for categoria in categorias:
                print(f'\nId categoría: {categoria[0]}')
                print(f'Nombre:       {categoria[1]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_copias(self):
        try:
            consulta = 'SELECT * FROM copia;'
            self.cursor.execute(consulta)
            copias = self.cursor.fetchall()
            for copia in copias:
                print(f'\nId copia:  {copia[0]}')
                print(f'Id libro:  {copia[1]}')
                print(f'Id idioma: {copia[2]}')
                print(f'Id estado: {copia[3]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_idiomas(self):
        try:
            consulta = 'SELECT * FROM idioma;'
            self.cursor.execute(consulta)
            idiomas = self.cursor.fetchall()
            for idioma in idiomas:
                print(f'\nId idioma: {idioma[0]}')
                print(f'Nombre:    {idioma[1]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_multas(self):
        try:
            consulta = 'SELECT * FROM multa;'
            self.cursor.execute(consulta)
            multas = self.cursor.fetchall()
            for multa in multas:
                print(f'\nId multa:        {multa[0]}')
                print(f'Valor:           {multa[1]}')
                print(f'Valor cancelado: {multa[2]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_plazos_extra(self):
        try:
            consulta = 'SELECT * FROM plazo_extra;'
            self.cursor.execute(consulta)
            plazos_extra = self.cursor.fetchall()
            for plazo_extra in plazos_extra:
                print(f'\nId plazo extra:  {plazo_extra[0]}')
                print(f'Días extra:      {plazo_extra[1]}')
                print(f'Veces extendido: {plazo_extra[2]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def listar_tipos_usuarios(self):
        try:
            consulta = 'SELECT * FROM tipo_usuario;'
            self.cursor.execute(consulta)
            tipos_usuarios = self.cursor.fetchall()
            for tipo_usuario in tipos_usuarios:
                print(f'\nId tipo usuario: {tipo_usuario[0]}')
                print(f'Nombre:          {tipo_usuario[1]}')
            print('\n', ' Fin submenú listados '.center(70, '='), sep='')
        except:
            pass

    def sp_insertar_modificar_autor(self, id_autor, nombre, apellido, fecha_nacimiento):
        try:
            self.cursor.callproc('sp_insertar_modificar_autor', [
                                 id_autor, nombre, apellido, fecha_nacimiento])
            resultado = self.cursor.fetchone()
            input(f'\n{resultado[0]}')
        except:
            pass

    def sp_insertar_modificar_editorial(self, id_editorial, nombre, correo, telefono, fecha_fundacion):
        try:
            self.cursor.callproc('sp_insertar_modificar_editorial', [
                                 id_editorial, nombre, correo, telefono, fecha_fundacion])
            resultado = self.cursor.fetchone()
            input(f'\n{resultado[0]}')
        except:
            pass

    def sp_insertar_modificar_libro(self, id_libro, id_editorial, titulo, fecha_publicacion):
        try:
            self.cursor.callproc('sp_insertar_modificar_libro', [
                                 id_libro, id_editorial, titulo, fecha_publicacion])
            resultado = self.cursor.fetchone()
            input(f'\n{resultado[0]}')
        except:
            pass

    def sp_insertar_modificar_usuario(self, id_usuario, nombre, apellido, id_tipo_usuario):
        try:
            self.cursor.callproc('sp_insertar_modificar_usuario', [
                                 id_usuario, nombre, apellido, id_tipo_usuario])
            resultado = self.cursor.fetchone()
            input(f'\n{resultado[0]}')
        except:
            pass
