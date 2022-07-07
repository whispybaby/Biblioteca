import db
import datetime


def main():
    biblioteca = db.ConexionBD('localhost', 'python', 'python', 'biblioteca')
    biblioteca.conectar_bd()

    print(' Sistema gestor de biblioteca '.center(70, '='))
    menu()

    while True:
        opcion = input('\nIngrese una opción: ')

        # Ver opciones
        if opcion == '?':
            menu()

        # Solicitar plazo extra
        elif opcion == '1':
            print('\n', ' Solicitar plazo extra '.center(70, '='), sep='')

            id_prestamo = input('Id del préstamo: ')
            try:
                id_prestamo = int(id_prestamo)
                if id_prestamo <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            biblioteca.sp_plazo_extra(id_prestamo)

        # Buscar copia
        elif opcion == '2':
            print('\n', ' Buscar copia '.center(70, '='), sep='')

            id_libro = input('Id del libro: ')
            try:
                id_libro = int(id_libro)
                if id_libro <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            biblioteca.sp_buscar_copia(id_libro)

        # Devolver prestamo
        elif opcion == '3':
            print('\n', ' Devolver préstamo '.center(70, '='), sep='')

            id_prestamo = input('Id del préstamo: ')
            try:
                id_prestamo = int(id_prestamo)
                if id_prestamo <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            biblioteca.sp_devolver_prestamo(id_prestamo)

        # Realizar préstamo
        elif opcion == '4':
            print('\n', ' Realizar préstamo '.center(70, '='), sep='')

            id_copia = input('Id de la copia: ')
            try:
                id_copia = int(id_copia)
                if id_copia <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            id_usuario = input('Id del usuario: ')
            try:
                id_usuario = int(id_usuario)
                if id_usuario <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            biblioteca.sp_realizar_prestamo(id_copia, id_usuario)

        # Pagar multa
        elif opcion == '5':
            print('\n', ' Pagar multa '.center(70, '='), sep='')

            id_prestamo = input('Id del préstamo: ')
            try:
                id_prestamo = int(id_prestamo)
                if id_prestamo <= 0:
                    raise ValueError
            except ValueError:
                print('\nEl id debe ser un número positivo.')
                continue

            monto_abono = input('Monto a abonar: ')
            try:
                monto_abono = int(monto_abono)
                if monto_abono < 0:
                    raise ValueError
            except ValueError:
                print('\nEl monto a abonar debe ser positivo.')
                continue

            biblioteca.sp_pagar_multa(id_prestamo, monto_abono)

        # Añadir/modificar registros
        elif opcion == '6':
            print('\n', ' Submenú añadir/modificar registros '.center(70, '='), sep='')
            menu_añadir_modificar()
            opcion_añadir_modificar = input('\nIngrese una opción: ')

            # Autor
            if opcion_añadir_modificar == '1':
                id_autor = input('\nId autor:       ')
                try:
                    id_autor = int(id_autor)
                    if id_autor <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                nombre = input('Nombre:         ')
                try:
                    if len(nombre) > 30:
                        raise ValueError
                except ValueError:
                    print('\nEl nombre no puede ser más largo de 30 carácteres.')
                    continue

                apellido = input('Apellido:       ')
                try:
                    if len(apellido) > 30:
                        raise ValueError
                except ValueError:
                    print('\nEl apellido no puede ser más largo de 30 carácteres.')
                    continue

                año_nacimiento = input('Año nacimiento: ')
                try:
                    año_nacimiento = int(año_nacimiento)
                    if año_nacimiento <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl año debe ser un número positivo.')
                    continue

                mes_nacimiento = input('Mes nacimiento: ')
                try:
                    mes_nacimiento = int(mes_nacimiento)
                    if mes_nacimiento > 12 or mes_nacimiento < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl mes debe ser un número entre 1 y 12.')
                    continue

                dia_nacimiento = input('Día nacimiento: ')
                try:
                    dia_nacimiento = int(dia_nacimiento)
                    if dia_nacimiento > 31 or dia_nacimiento < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl día debe ser un número entre 1 y 31.')
                    continue

                try:
                    fecha_nacimiento = datetime.datetime(
                        año_nacimiento, mes_nacimiento, dia_nacimiento)
                except ValueError:
                    print('\nNo es una fecha válida.')
                    continue

                biblioteca.sp_insertar_modificar_autor(
                    id_autor, nombre, apellido, fecha_nacimiento)

                print(
                    '\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Editorial
            elif opcion_añadir_modificar == '2':
                id_editorial = input('\nId editorial:  ')
                try:
                    id_editorial = int(id_editorial)
                    if id_editorial <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                nombre = input('Nombre:        ')
                try:
                    if len(nombre) > 20:
                        raise ValueError
                except ValueError:
                    print('\nEl nombre no puede ser más largo de 20 carácteres.')
                    continue

                correo = input('Correo:        ')
                try:
                    if len(correo) > 45:
                        raise ValueError
                except ValueError:
                    print('\nEl correo no puede ser más largo de 45 carácteres.')
                    continue

                telefono = input('Teléfono:      ')
                try:
                    if len(telefono) > 25:
                        raise ValueError
                except ValueError:
                    print('\nEl telefono no puede ser más largo de 25 carácteres.')
                    continue

                año_fundacion = input('Año fundacion: ')
                try:
                    año_fundacion = int(año_fundacion)
                    if año_fundacion <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl año debe ser un número positivo.')
                    continue

                mes_fundacion = input('Mes fundacion: ')
                try:
                    mes_fundacion = int(mes_fundacion)
                    if mes_fundacion > 12 or mes_fundacion < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl mes debe ser un número entre 1 y 12.')
                    continue

                dia_fundacion = input('Día fundacion: ')
                try:
                    dia_fundacion = int(dia_fundacion)
                    if dia_fundacion > 31 or dia_fundacion < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl día debe ser un número entre 1 y 31.')
                    continue

                try:
                    fecha_fundacion = datetime.datetime(
                        año_fundacion, mes_fundacion, dia_fundacion)
                except ValueError:
                    print('\nNo es una fecha válida.')
                    continue

                biblioteca.sp_insertar_modificar_editorial(
                    id_editorial, nombre, correo, telefono, fecha_fundacion)

                print(
                    '\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Libro
            elif opcion_añadir_modificar == '3':
                id_libro = input('\nId libro:             ')
                try:
                    id_libro = int(id_libro)
                    if id_libro <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                id_editorial = input('Id editorial:         ')
                try:
                    id_editorial = int(id_editorial)
                    if id_editorial <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                titulo = input('Título:               ')
                try:
                    if len(titulo) > 60:
                        raise ValueError
                except ValueError:
                    print('\nEl título no puede ser de más de 60 carácteres.')

                año_publicacion = input('Año publicacion: ')
                try:
                    año_publicacion = int(año_publicacion)
                    if año_publicacion <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl año debe ser un número positivo.')
                    continue

                mes_publicacion = input('Mes publicacion: ')
                try:
                    mes_publicacion = int(mes_publicacion)
                    if mes_publicacion > 12 or mes_publicacion < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl mes debe ser un número entre 1 y 12.')
                    continue

                dia_publicacion = input('Día publicacion: ')
                try:
                    dia_publicacion = int(dia_publicacion)
                    if dia_publicacion > 31 or dia_publicacion < 1:
                        raise ValueError
                except ValueError:
                    print('\nEl día debe ser un número entre 1 y 31.')
                    continue

                try:
                    fecha_publicacion = datetime.datetime(
                        año_publicacion, mes_publicacion, dia_publicacion)
                except ValueError:
                    print('\nNo es una fecha válida.')
                    continue

                biblioteca.sp_insertar_modificar_libro(
                    id_libro, id_editorial, titulo, fecha_publicacion)

                print(
                    '\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Usuario
            elif opcion_añadir_modificar == '4':
                id_usuario = input('\nId usuario:      ')
                try:
                    id_usuario = int(id_usuario)
                    if id_usuario <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                nombre = input('Nombre:          ')
                try:
                    if len(nombre) > 30:
                        raise ValueError
                except ValueError:
                    print('\nEl nombre no puede ser más largo de 30 carácteres.')
                    continue

                apellido = input('Apellido:        ')
                try:
                    if len(apellido) > 30:
                        raise ValueError
                except ValueError:
                    print('\nEl apellido no puede ser más largo de 30 carácteres.')
                    continue

                id_tipo_usuario = input('Id tipo usuario: ')
                try:
                    id_tipo_usuario = int(id_tipo_usuario)
                    if id_tipo_usuario <= 0:
                        raise ValueError
                except ValueError:
                    print('\nEl id debe ser un número positivo.')
                    continue

                biblioteca.sp_insertar_modificar_usuario(
                    id_usuario, nombre, apellido, id_tipo_usuario)

                print(
                    '\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            else:
                print('\nOpción no válida.')

        # Listar registros
        elif opcion == '7':
            print('\n', ' Submenú listados '.center(70, '='), sep='')
            menu_registros()
            opcion_registros = input('\nIngrese una opción: ')

            # Libros
            if opcion_registros == '1':
                biblioteca.listar_libros()

            elif opcion_registros == '2':
                biblioteca.listar_usuarios()

            elif opcion_registros == '3':
                biblioteca.listar_prestamos()

            elif opcion_registros == '4':
                biblioteca.listar_autores()

            elif opcion_registros == '5':
                biblioteca.listar_estados()

            elif opcion_registros == '6':
                biblioteca.listar_editoriales()

            elif opcion_registros == '7':
                biblioteca.listar_categorias()

            elif opcion_registros == '8':
                biblioteca.listar_copias()

            elif opcion_registros == '9':
                biblioteca.listar_idiomas()

            elif opcion_registros == '10':
                biblioteca.listar_multas()

            elif opcion_registros == '11':
                biblioteca.listar_plazos_extra()

            elif opcion_registros == '12':
                biblioteca.listar_tipos_usuarios()

            else:
                print('\nOpción no válida.')

        elif opcion == '8':
            print('\n', ' Confirmar cambios '.center(70, '='), sep='')

            desicion = input('Sí, si o s para confirmar los cambios: ')
            if desicion.lower() in ('sí', 'si', 's'):
                biblioteca.guardar_cambios()

        # Salir
        elif opcion == '9':
            print('\nSaliendo...')
            break

        else:
            print('\nOpción no válida.')


def menu():
    print('\n? - Ver las opciones')
    print('1 - Solicitar plazo extra')
    print('2 - Buscar copia')
    print('3 - Devolver prestamo ')
    print('4 - Realizar préstamo')
    print('5 - Pagar multa')
    print('6 - Añadir/modificar registros')
    print('7 - Listar registros')
    print('8 - Guardar los cambios')
    print('9 - Salir')


def menu_registros():
    print('\n1  - Libros')
    print('2  - Usuarios')
    print('3  - Préstamos')
    print('4  - Autores')
    print('5  - Estados')
    print('6  - Editoriales')
    print('7  - Categorías')
    print('8  - Copias')
    print('9  - Idiomas')
    print('10 - Multas')
    print('11 - Plazos extra')
    print('12 - Tipos de usuario')


def menu_añadir_modificar():
    print('\n1  - Autores')
    print('2  - Editoriales')
    print('3  - Libros')
    print('4  - Usuarios')


if __name__ == '__main__':
    main()
