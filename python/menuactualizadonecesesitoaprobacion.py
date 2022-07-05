print("Sistema de busqueda de libros porfavor introduce la operacion que deceas realizar")
def error(e):
    print(f"Error {e.args[0]}: {e.args[1]}")

def menu():
    print("1 - Solicitar plazo extra")
    print("2 - Buscar copia")
    print("3 - Devolver copia ")
    print("4 - Prestar copia")
    print("5 - Salir")


while(estado):
    menu()
    opcion = input("\nIngrese una opción: ")

    # Plazo extra
    if opcion == "1":
        print("\nSolicitar plazo extra. ")
        sp_plazo_extra()

    # Buscar copia
    elif opcion == "2":
        print("\nBuscar copia.")
        sp_buscar_copia()

    # Devolver copia
    elif opcion == "3":
        print("\nListar vehículos.")
        sp_devolver_copia()
    
    #Prestar copia
    elif opcion == "4":
        print("\nPresytar copia.")
        copia = input("Copia: ")
        sp_prestar_copia(copia)
    

    # Salir
    elif opcion == "5":
        estado = False
        print("\nSaliendo...")

    else:
        print("\nOpción no válida.")