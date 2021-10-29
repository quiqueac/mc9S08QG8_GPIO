;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            
;
; export symbols
;
            XDEF _Startup
            ABSENTRY _Startup

;
; variable/data section
;
            ORG    RAMStart         ; Insert your data definition here
ExampleVar: DS.B   1

;
; code section
;
            ORG    ROMStart
            

_Startup:
            LDHX   #RAMEnd+1        ; initialize the stack pointer
            TXS
            CLI			; enable interrupts

mainLoop:
            ; Insert your code here
            LDA		#$80			; Unicamente pin 7 del puerto B como salida
            STA		PTBDD			; Guardar en el registro correspondiente
Parpadeo:	
			LDA		#$FF			; Inicio del retardo
Retardo:
			DBNZA	Retardo			; Decrementa acumulador y brinca si no es cero
			
			LDA		PTBD			; Carga en el acumulador el contenido del puerto B
			COMA					; Operacion logica NOT con el acumulador
			STA		PTBD			; Guardar el acmulador en el puerto B
			
			BRA		Parpadeo		; Repetir indefinidamente
			
            BRA    	mainLoop
			
;**************************************************************
;* spurious - Spurious Interrupt Service Routine.             *
;*             (unwanted interrupt)                           *
;**************************************************************

spurious:				; placed here so that security value
			NOP			; does not change all the time.
			RTI

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************

            ORG	$FFFA

			DC.W  spurious			;
			DC.W  spurious			; SWI
			DC.W  _Startup			; Reset
