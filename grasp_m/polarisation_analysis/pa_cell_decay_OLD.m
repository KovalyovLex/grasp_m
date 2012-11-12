function PHe = pa_cell_decay(PHe0,t1,t)


%Calculate current 3He polarisation after decay

PHe = PHe0 * exp(-t/t1);
