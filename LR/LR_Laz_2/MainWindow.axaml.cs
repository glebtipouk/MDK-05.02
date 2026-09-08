using Avalonia.Controls;
using Avalonia.Interactivity;

namespace TestApp;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    // Эта функция должна называться В ТОЧНОСТИ как в файле .axaml
    public void OnButtonClick(object sender, RoutedEventArgs e)
    {
        // Находим блок текста по имени и меняем его содержимое
        MyTitle.Text = "Ура! Всё работает!";
    }
}