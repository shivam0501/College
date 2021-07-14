x = int(input('Enter the Rating for Food Quality [0-10] :'))
y = int(input('Enter the Rating for Service [0-10] :'))

'''
Input Descriptors:
1) Food Quality [0-10]:
    i) VP : Very Poor
    ii)P: Poor
    iii)G: Good
    iv)E: Excellent
2) Service[0-10]:
    i) VP : Very Poor
    ii)P: Poor
    iii)G: Good
    iv)E: Excellent
Ouput Descriptor:
1) Tip [0-25%]:
    i) VL: Very Less
    ii) L: Less
    iii) N: Normal
    iv) H: High
    v) VH: Very High
'''

#Food Quality Membership Function

fq_vp = 0
if 0 <= x <= 5:
    fq_vp = (5 - x) / 5

fq_p = 0
if 0 <= x <= 5:
    fq_p  = x / 50
if 5 <= x <= 8:
    fq_p  = (8 - x) / 3

fq_g = 0
if 5 <= x <= 8:
    fq_g = (x - 5) / 3
if 8 <= x <= 10:
    fq_g = (10-x) /  2

fq_e = 0
if 8 <= x <= 10:
    fq_e = (x - 8) / 2

#Service Membership Function

s_vp = 0
if 0 <= y <= 5:
    s_vp = (5 - y) / 5

s_p = 0
if 0 <= y <= 5:
    s_p  = y / 50
if 5 <= y <= 8:
    s_p  = (8 - y) / 3

s_g = 0
if 5 <= y <= 8:
    s_g = (y - 5) / 3
if 8 <= y <= 10:
    s_g = (10-y) /  2

s_e = 0
if 8 <= y <= 10:
    s_e = (y - 8) / 2

    
r1 = min(fq_vp, s_vp)
r2 = min(fq_vp, s_p)
r3 = min(fq_vp, s_g)
r4 = min(fq_vp, s_e)
r5 = min(fq_p, s_vp)
r6 = min(fq_p, s_p)
r7 = min(fq_p, s_g)
r8 = min(fq_p, s_e)
r9 = min(fq_g, s_vp)
r10 = min(fq_g, s_p)
r11 = min(fq_g, s_g)
r12 = min(fq_g, s_e)
r13 = min(fq_e, s_vp)
r14 = min(fq_e, s_p)
r15 = min(fq_e, s_g)
r16 = min(fq_e, s_e)

out = max(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16)
if r1 == out or r2 == out or r5 == out:
    vl = out
    z = 5 - 5 * vl
if r3 == out or r4 == out or r6 == out or r7 == out or r9 == out or r13 == out :
    l = out
    z1 = 5 * l
    z2 = 10 - 5 * l
    z = (z1 + z2) / 2
if r8 == out or r10 == out or r14 == out:
    n = out
    z1 = 5 * n + 5
    z2 = 20 - 10 * n
    z = (z1 + z2) / 2
if r11 == out or r12 == out :
    h = out
    z1 = 10 * h + 10
    z2 = 25 - 5 * h
    z = (z1 + z2) / 2
if r15 == out or r16 == out:
    vh = out
    z = 20 + 5 *vh
print('The calculated Tip is : {0} %'.format(z))
