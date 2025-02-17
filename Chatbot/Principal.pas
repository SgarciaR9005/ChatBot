unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.ExtCtrls,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, Data.DB, Vcl.ComCtrls, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet;


  var
   Estado: Integer;
   Identificacion: Integer;
   Opcion: Integer;
   CodigoProducto: Integer;



type
  Tp = class(TForm)
    Memopeticion: TMemo;
    btEnviar: TButton;
    PnMenu: TPanel;
    FDConnection: TFDConnection;
    Label1: TLabel;
    MemoRespuesta: TRichEdit;
    FDQuery1: TFDQuery;
    TimerOut: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
    procedure ReiniciaMenu(Sender: TObject);
  private
    { Private declarations }
    procedure Conectarbasededatos;
    procedure AgregarLineaMemo(Linea: String; Color: TColor);
    procedure LimpiarMemoSiExcede;
    procedure MostrarMensajeBienvenida;
    procedure MostrarMenuPrincipal;
    procedure RevisionCategorias;
    procedure MostrarProductosPorCategoria(CategoriaID: Integer; CategoriaNombre: String);
    procedure RevisionCantidadProductosPorSede;
    procedure ConsultaProductoPorSede(CodigoProducto: Integer);
    procedure ProcesarPeticion(Peticion :String);
    procedure VerificarIdentificacionUsuario(Identificacion: Integer);
    procedure MostrarProductosyPreciosporSede;
  public
    { Public declarations }
  end;

var
  p: Tp;

implementation

{$R *.dfm}

{ Tp }

procedure Tp.AgregarLineaMemo(Linea: String; Color: TColor);
begin
  MemoRespuesta.Lines.BeginUpdate; // Evitar parpadeo durante la actualización
  try
    MemoRespuesta.SelAttributes.Color := Color;
    MemoRespuesta.Lines.Add(Linea);
    LimpiarMemoSiExcede;
    // Desplazar automáticamente a la última línea
    MemoRespuesta.SelStart := MemoRespuesta.GetTextLen;
    MemoRespuesta.Perform(EM_SCROLLCARET, 0, 0);
  finally
    MemoRespuesta.Lines.EndUpdate; // Finalizar la actualización
  end;
end;

procedure Tp.LimpiarMemoSiExcede;
begin
  while MemoRespuesta.Lines.Count > 2000 do
    MemoRespuesta.Lines.Delete(0);
end;

procedure Tp.ConsultaProductoPorSede(CodigoProducto: Integer);
begin
  FDQuery1.Connection := FDConnection;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT s.Nombre AS Sucursal, p.Nombre AS Producto,');
  FDQuery1.SQL.Add('SUM(CASE WHEN mi.TipoMovimiento = ''Ingreso'' THEN mi.Cantidad ELSE 0 END) -');
  FDQuery1.SQL.Add('SUM(CASE WHEN mi.TipoMovimiento = ''Salida'' THEN mi.Cantidad ELSE 0 END) AS Cantidad');
  FDQuery1.SQL.Add('FROM MovimientosInventario mi');
  FDQuery1.SQL.Add('JOIN Productos p ON mi.ProductoID = p.ProductoID');
  FDQuery1.SQL.Add('JOIN Ubicaciones u ON mi.UbicacionID = u.UbicacionID');
  FDQuery1.SQL.Add('JOIN Sucursales s ON u.SucursalID = s.SucursalID');
  FDQuery1.SQL.Add('WHERE p.ProductoID = :CodigoProducto');
  FDQuery1.SQL.Add('GROUP BY s.Nombre, p.Nombre');
  FDQuery1.ParamByName('CodigoProducto').AsInteger := CodigoProducto;
  FDQuery1.Open;

  AgregarLineaMemo('Consulta de producto por sede:', clBlue);
  while not FDQuery1.Eof do
  begin
    AgregarLineaMemo('Sucursal: ' + FDQuery1.FieldByName('Sucursal').AsString + ' - Producto: ' + FDQuery1.FieldByName('Producto').AsString + ' - Cantidad: ' + FDQuery1.FieldByName('Cantidad').AsString, clBlack);
    FDQuery1.Next;
  end;
end;

procedure Tp.btEnviarClick(Sender: TObject);
var
  Peticion: string;
begin
  Peticion := MemoPeticion.Text;
  MemoPeticion.Clear; // Limpiar el campo de petición después de enviar
  AgregarLineaMemo('   ',clblack);
  AgregarLineaMemo(Peticion, clTeal);
  ProcesarPeticion(Trim(Peticion));
end;


procedure Tp.Conectarbasededatos;
begin
  try
    FDConnection.DriverName := 'MSSQL';
    FDConnection.Params.Add('Server=localhost');
    FDConnection.Params.Add('Database=Inventarios');
    FDConnection.Params.Add('User_Name=');
    FDConnection.Params.Add('Password=');
    FDConnection.Params.Add('OSAuthent=Yes');
    FDConnection.LoginPrompt := False;
    FDConnection.Connected := True;

    if FDConnection.Connected then
    Label1.Caption:=('Conexión: Conexión establecida exitosamente')
    else
      Label1.Caption:=('Conexión:Error al establecer la conexión');
  except
    on E: Exception do
      Label1.Caption:=('Conexión:'+'Error: ' + E.Message);
  end;

end;
procedure Tp.FormCreate(Sender: TObject);
begin
Conectarbasededatos;
MostrarMensajeBienvenida;
  Estado := 1;
  Identificacion := 0;
  Opcion := 0;
  CodigoProducto := 0;
end;

procedure Tp.ReiniciaMenu(Sender: TObject);
begin
 if(MemoPeticion.Text  = '') then
 begin
 AgregarLineaMemo('No hemos recibido ninguna información adicional, fue un gusto atenderte',clfuchsia);
 AgregarLineaMemo('',clwhite);
 MostrarMensajeBienvenida;
  Estado:=1;
  Identificacion := 0;
  Opcion := 0;
  CodigoProducto := 0;
 end;
end;

procedure Tp.RevisionCantidadProductosPorSede;
begin
  FDQuery1.Connection := FDConnection;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT s.Nombre AS Sucursal, p.Nombre AS Producto,');
  FDQuery1.SQL.Add('SUM(CASE WHEN mi.TipoMovimiento = ''Ingreso'' THEN mi.Cantidad ELSE 0 END) -');
  FDQuery1.SQL.Add('SUM(CASE WHEN mi.TipoMovimiento = ''Salida'' THEN mi.Cantidad ELSE 0 END) AS Cantidad');
  FDQuery1.SQL.Add('FROM MovimientosInventario mi');
  FDQuery1.SQL.Add('JOIN Productos p ON mi.ProductoID = p.ProductoID');
  FDQuery1.SQL.Add('JOIN Ubicaciones u ON mi.UbicacionID = u.UbicacionID');
  FDQuery1.SQL.Add('JOIN Sucursales s ON u.SucursalID = s.SucursalID');
  FDQuery1.SQL.Add('GROUP BY s.Nombre, p.Nombre');
  FDQuery1.Open;
  AgregarLineaMemo('Cantidad de productos por sede:', clBlue);
  while not FDQuery1.Eof do
  begin
    AgregarLineaMemo(FDQuery1.FieldByName('Sucursal').AsString + ' - ' + FDQuery1.FieldByName('Producto').AsString + ': ' + FDQuery1.FieldByName('Cantidad').AsString, clBlack);
    FDQuery1.Next;
  end;
end;

procedure Tp.MostrarMensajeBienvenida;
begin
  AgregarLineaMemo('Bienvenidos a tu agente virtual de Inventarios:',clred);
  AgregarLineaMemo('-------------------------------------------------',clred);
  AgregarLineaMemo('Digita tu número de identificación para continuar...',clred);
end;

procedure Tp.MostrarMenuPrincipal;
begin
  AgregarLineaMemo('*** El día de hoy como te puedo ayudar (Seleccione una opción):',clred);
  AgregarLineaMemo('1- Revisión de categorías de productos',clred);
  AgregarLineaMemo('2- Revisión de cantidad de productos por sede',clred);
 AgregarLineaMemo(' 3- ¿Deseas saber la cantidad de productos y sus precios por sede?',clred);
end;

procedure Tp.RevisionCategorias;
var
  CategoriaID: Integer;
begin
  FDQuery1.Connection := FDConnection;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT CategoriaID, Nombre, Descripcion FROM Categorias');
  FDQuery1.Open;
  AgregarLineaMemo('Categorías de productos y sus productos asociados:', clBlue);
  while not FDQuery1.Eof do
  begin
    CategoriaID := FDQuery1.FieldByName('CategoriaID').AsInteger;
    AgregarLineaMemo(FDQuery1.FieldByName('Nombre').AsString + ': ' + FDQuery1.FieldByName('Descripcion').AsString, clBlack);
    MostrarProductosPorCategoria(CategoriaID, FDQuery1.FieldByName('Nombre').AsString);
    FDQuery1.Next;
  end;
end;

procedure Tp.MostrarProductosPorCategoria(CategoriaID: Integer; CategoriaNombre: String);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection; // Usando la conexión configurada
    Query.SQL.Clear;
    Query.SQL.Add('SELECT Nombre, Descripcion FROM Productos WHERE CategoriaID = :CategoriaID');
    Query.ParamByName('CategoriaID').AsInteger := CategoriaID;
    Query.Open;
    AgregarLineaMemo('Productos en la categoría ' + CategoriaNombre + ':', clGreen);
    while not Query.Eof do
    begin
      AgregarLineaMemo('  - ' + Query.FieldByName('Nombre').AsString + ': ' + Query.FieldByName('Descripcion').AsString, clGray);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
 end;


procedure Tp.MostrarProductosyPreciosporSede;
begin
  FDQuery1.SQL.Text := 'SELECT s.Nombre AS Sucursal, p.Nombre AS Producto, ' +
                      'SUM(CASE WHEN mi.TipoMovimiento = ''Ingreso'' THEN mi.Cantidad ELSE -mi.Cantidad END) AS Cantidad, ' +
                      'p.PVP AS Precio ' +
                      'FROM Sucursales s ' +
                      'JOIN Ubicaciones u ON s.SucursalID = u.SucursalID ' +
                      'JOIN MovimientosInventario mi ON u.UbicacionID = mi.UbicacionID ' +
                      'JOIN Productos p ON mi.ProductoID = p.ProductoID ' +
                      'GROUP BY s.Nombre, p.Nombre, p.PVP ' +
                      'ORDER BY s.Nombre, p.Nombre';
  FDQuery1.Open;

  while not FDQuery1.Eof do
  begin
    AgregarLineaMemo('Sucursal: ' + FDQuery1.FieldByName('Sucursal').AsString, clBlue);
    AgregarLineaMemo('Producto: ' + FDQuery1.FieldByName('Producto').AsString, clBlue);
    AgregarLineaMemo('Cantidad: ' + FDQuery1.FieldByName('Cantidad').AsString, clBlue);
    AgregarLineaMemo('Precio: ' + FDQuery1.FieldByName('Precio').AsString, clBlue);
    AgregarLineaMemo('-----------------------------', clBlue);
    FDQuery1.Next;
  end;
end;

procedure Tp.ProcesarPeticion(Peticion: string);
begin
   Timerout.Enabled:= False;

  case Estado of
    0: // Estado inicial
      begin
        MostrarMensajeBienvenida;
        Estado := 1;
        Timerout.Enabled:=True;
      end;
    1: // Solicitar identificación
      begin
        Identificacion := StrToIntDef(Peticion, 0);
        if Identificacion > 0 then begin
          VerificarIdentificacionUsuario(Identificacion);

       end else
        begin
          AgregarLineaMemo('Identificación no válida. Por favor, intenta de nuevo.', clRed);
          ReiniciaMenu(nil);
        end;
      end;
    2: // Mostrar menú principal y procesar opción
      begin
        Opcion := StrToIntDef(Peticion,0);
        case Opcion of
          1  : begin
                 RevisionCategorias;
                 Estado := 3;
                end;
          2 :  begin
                 RevisionCantidadProductosPorSede;
                 Estado := 3;
               end;
          3  : begin
                 MostrarProductosyPreciosporSede;
                 Estado := 3;
               end;
        else
          AgregarLineaMemo('Opción no válida. Por favor, selecciona una opción del menú.', clRed);
        end;
      end;
   3: // Preguntar si hay algo más en lo que pueda ayudar
      begin
        AgregarLineaMemo('¿Hay algo más en lo que te pueda ayudar? (sí/no)', clBlue);
        if Peticion.ToLower = 'sí' then
        begin
          MostrarMenuPrincipal;
          Estado := 2;
        end
        else
        begin
          AgregarLineaMemo('Gracias por usar el agente virtual de Inventarios. ¡Hasta luego!', clBlue);
          Estado := 0; // Reiniciar el estado
        end;
      end;
  end;
end;
procedure Tp.VerificarIdentificacionUsuario(Identificacion: Integer);
begin
  FDQuery1.Connection := FDConnection; // Asegurando que FDQuery1 esté conectado a FDConnection
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT COUNT(*) AS UsuarioExiste FROM Usuarios WHERE Identificacion = :Identificacion');
  FDQuery1.ParamByName('Identificacion').AsInteger := Identificacion;
  FDQuery1.Open;

  if FDQuery1.FieldByName('UsuarioExiste').AsInteger > 0 then
  begin
    MostrarMenuPrincipal;
    Estado := 2;
    Timerout.Enabled:=True;
  end
  else
  begin
    AgregarLineaMemo('Identificación no reconocida. Por favor, intenta de nuevo.', clRed);
    Estado := 0; // Volver al estado inicial
  end;
end;


end.
