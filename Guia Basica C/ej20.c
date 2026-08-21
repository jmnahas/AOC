int b, c; //Scope File - Duracion estatica

void f(void)
{
    int b, d; // Scope Bloque- Duracion automatica
}
void g(int a)
{
    int c; // Scope Bloque-Duracion automatica
    {
        int a, d; // Scope Bloque-Duracion automatica
    }
}