class Server{
  final String _name;
  final String _ipAdress;
  final String _ipV6Address;
  final String _portNumber;
  final String _clientMessagePortNumber;
  final String _httpPortNumber;
  final String _usingSSL;
  final String _acceptingClients;

  Server(this._name, this._ipAdress, this._ipV6Address, this._portNumber,
      this._clientMessagePortNumber, this._httpPortNumber, this._usingSSL,
      this._acceptingClients);


}