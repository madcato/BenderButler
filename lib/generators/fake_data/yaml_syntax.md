# Yaml syntaxt to create data types, functions, tables, etc

## Data types

- binary
- boolean
- date
- datetime
- decimal
- float
- integer
- primary_key
- string
- text
- time
- timestamp


## Functions 

---
functions:
  - function\_name1:
      - param1: data\_type
	  - param2: data\_type
	  - paramN: data\_type
  - function\_name2:
      - param1: data\_type
	  - param2: data\_type
	  - paramN: data\_type
...
### Sample 

functions:
  - prueba1:
      - run: integer
      - name: strign
  - preuba2:
      - tromba: Bool
)

## Structures

---
classes:
  - class\_name1:
	  - property1: data\_type
	  - property2: data\_type
	  - propertyN: data\_type
