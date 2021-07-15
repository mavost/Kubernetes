new:
	vagrant up

fresh: clean
	vagrant up

clean:
	vagrant destroy -f
	rm -rf .vagrant
	rm -f roles/iad*
# ceph-related
	rm -f cephDisk*
	