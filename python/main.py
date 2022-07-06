import db
biblioteca = db.ConexionBD("localhost","python","python","biblioteca")
print("Sistema de busqueda de libros porfavor introduce la operacion que deceas realizar")

def menu():
    print("1 - Solicitar plazo extra")
    print("2 - Buscar copia")
    print("3 - Devolver copia ")
    print("4 - Prestar copia")
    print("5 - Salir")

estado = True
while(estado):
     menu()
     opcion = input("\n")

    # Plazo extra
     if opcion == "1":
          print("\nSolicitar plazo extra. ")
          id_prestamo=input("Porfavor ingrese el id del prestamo:     ")
          biblioteca.sp_plazo_extra(id_prestamo)

    # Buscar copia
     elif opcion == "2":
          print("\nBuscar copia.")
          id_copia=input("Ingrese el id de la copia:     ")
          biblioteca.sp_buscar_copia()

    # Devolver prestamo
     elif opcion == "3":
          print("\nDevolver prestamo.")
          id_prestamo=int(input("Ingrese el id del prestamo:      "))
          biblioteca.sp_devolver_prestamo(id_prestamo)
    
    #Prestar copia
     elif opcion == "4":
          print("\nPrestar copia.")
          copia = input("Copia: ")
          biblioteca.sp_prestar_copia()
     
     #Pagar multa
     elif opcion == "5":
          print("\nPagar multa. ")
          biblioteca.sp_pagar_multa()
    # Salir
     elif opcion == "5":
          estado = False
          print("\nSaliendo...")

     else:
          print("\nOpción no válida.")