pragma solidity >=0.4.24 <0.9.0;
pragma experimental ABIEncoderV2;


contract Notas {
    // direccion del profesor
    address public profesor;

    //constructor construye las variables principales del smart contract
    constructor() public {
        profesor = msg.sender;
    }
    // mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping (bytes32 => uint) notas;

    //array de los alumnos que pidan revisiones de examen
    string[] revisiones;

    // eventos
    event alumno_evaluado(bytes32);
    event pedir_revision(string);

    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){
        //hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // relacion entre el hash de la identificacion del alumno y su nota
        notas[hash_idAlumno] = _nota;
        //emision del evento
        emit alumno_evaluado(hash_idAlumno);
    }

    modifier UnicamenteProfesor(address _direccion){
        // requiere que la direccion introducido por parametro sea igual al owner del contrato
        require(_direccion == profesor, "No tienes permiso para ejecutar esta funcion.");
        _;
    }

    //function para ver las notas de un alumno
    function verNotas(string memory _idAlumno) public view returns(uint) {
        // hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //nota asociada al hash del alumno
        uint nota_alumno = notas[hash_idAlumno];
        // visualizar la nota con el return
        return nota_alumno;
    }

    //function para pedir una revision del examen
    function revision(string memory _idAlumno) public {
        // almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        //emision del evento
        emit pedir_revision(_idAlumno);
    }

    //function para ver los alumnos que han solicitado revision de examen
    function verRevisiones() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        return revisiones;
    }
}