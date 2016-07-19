Neuaufbau der Mocap-DB - komplettes Beispiel
============================================


* Ausgangssituation:
--------------------

D:\einPfad\HDM
            |
            --2005_08_10_Bjorn
            |
            --2005_08_11_Bastian
            |
            --2005_08_11_Tido
            |
            --2005_08_12_Daniel
            |
            --2005_08_12_Meinard


* gewünschte Endsituation:
--------------------------

E:\einandererPfad\HDM05
		    |
		    --C3D
		    |   |
		    |   --bd
		    |   |
		    |   --bk
		    |   |
		    |   --dg
		    |   |
		    |   --mm
		    |   |
		    |   --tr
		    |
		    --AMC
			|
			--bd
			|
			--bk
			|
			--dg
			|
			--mm
			|
			--tr

* Vorgehensweise:
-----------------

1.) nameMap = mocapRenamer('D:\einPfad\HDM', 'E:\einandererPfad\HDM05', false, 'HDM05');

Kopiert die Mocap-Dateien in die neue Verzeichnisstruktur.


2.) cutMappingsRenamer( D:\pfadZuCutMappings\, E:\einandererPfad\neueCutMappings\, nameMap, 'HDM05' );

Passt die CutMapping-Dateien den neuen Dateinamen an.


3.) createMATs('E:\einandererPfad\HDM05\')

Erzeugt zu allen Mocap-Dateien die passenden *.MAT-Dateien, indem jede Datei einmal gelesen wird.


4.) applyCutMapping( 'E:\einandererPfad\neueCutMappings\', 'E:\einandererPfad\HDM05', 'E:\einandererPfad\HDM05\cuts')

Wendet die Cutmappings auf die Datenbank an und schreibt die geschittenen Dateien in 'E:\einandererPfad\HDM05\cuts'.


5.a) sortCutFiles('E:\einandererPfad\HDM05\cuts\c3d')
5.b) sortCutFiles('E:\einandererPfad\HDM05\cuts\amc')

Sortiert die verschiedenen Kategorien in Unterverzeichnisse ein.

6.) Eventuell noch Umbenennen einiger Verzeichnisse

z.B. 'asf_amc' in 'amc' usw.