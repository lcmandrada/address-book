# Address Book

**Legacy Project**

A basic linux script written for BASH for handling an address book.

It can:
- add a contact
- edit an existing contact
- delete an existing contact
- view every contact
- sort and view every contact
- find an existing contact
- load contacts by batch

# Run

Add an execute permission to the file.
```bash
sudo chmod +x book.bash
```

Execute by filename if path is added to the PATH variable
```bash
PATH="$PATH:<path>"
book.bash
```

or by absolute or relative path.
```bash
<absolute path>/book.bash
<relative path>/book.bash
```