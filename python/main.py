import db


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
                print('\nEl monto a abonar debe ser positivo')
                continue

            biblioteca.sp_pagar_multa(id_prestamo, monto_abono)

        # Añadir/modificar registros
        elif opcion == '6':
            print('\n', ' Submenú añadir/modificar registros '.center(70, '='), sep='')
            menu_añadir_modificar()
            opcion_añadir_modificar = input('\nIngrese una opción: ')

            # Autor
            if opcion_añadir_modificar == '1':
                id_autor = input('\nId autor:            ')
                nombre = input('Nombre:              ')
                apellido = input('Apellido:            ')
                fecha_nacimiento = input('Fecha de nacimiento: ')
                biblioteca.sp_insertar_modificar_autor(id_autor, nombre, apellido, fecha_nacimiento)

                print('\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Editorial
            elif opcion_añadir_modificar == '2':
                id_editorial = input('\nId editorial:    ')
                nombre = input('Nombre:          ')
                correo = input('Correo:          ')
                telefono = input('Teléfono:        ')
                fecha_fundacion = input('Fecha fundación: ')
                biblioteca.sp_insertar_modificar_editorial(id_editorial, nombre, correo, telefono, fecha_fundacion)

                print('\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Libro
            elif opcion_añadir_modificar == '3':
                id_libro = input('\nId libro:             ')
                id_editorial = input('Id editorial:         ')
                titulo = input('Título:               ')
                fecha_publicacion = input('Fecha de publicación: ')
                biblioteca.sp_insertar_modificar_libro(id_libro, id_editorial, titulo, fecha_publicacion)

                print('\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

            # Usuario
            elif opcion_añadir_modificar == '4':
                id_usuario = input('\nId usuario:      ')
                nombre = input('Nombre:          ')
                apellido =  input('Apellido:        ')
                id_tipo_usuario = input('Id tipo usuario: ')
                biblioteca.sp_insertar_modificar_usuario(id_usuario, nombre, apellido, id_tipo_usuario)

                print('\n', ' Fin submenú añadir/modificar registros '.center(70, '='), sep='')

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
            print('\n\nOpción no válida.')


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
