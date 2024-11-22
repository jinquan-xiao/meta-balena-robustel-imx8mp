OBJS=read-base-macaddr.o
TARGET=read-base-macaddr

$(TARGET): $(OBJS)
    $(CC) $(CFLAGS) $(LDFLAGS) $^ -o $(TARGET)

%.o:%.c
    $(CC) -c -o $@ $<

install:
    install -d $(DESTDIR)
    install -m 0755 $(TARGET) $(DESTDIR)

uninstall:
    ${RM} $(DESTDIR)/$(TARGET)

clean:
    $(RM) $(TARGET) $(OBJS)

.PHONY: install uninstall clean