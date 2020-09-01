import time

def track_elapsed_time():
    t_begin = time.time()
    for i in range(1000000):
        a = 1*2*3*4*5*6*7*8*9*10

    t_elapsed = time.time() - t_begin

    with open('output/time.txt', 'a') as fp:
        fp.write(f"{t_elapsed} seconds\n")




if __name__ == "__main__":
    track_elapsed_time()