#ifndef __DYNMATRIX_H
#define __DYNMATRIX_H

template<typename T>
class DynMatrix
{
public:
	DynMatrix();
	DynMatrix(const DynMatrix& other);
	DynMatrix(unsigned int n,unsigned int m,T* data = 0);
   ~DynMatrix();

   unsigned int getN() const{return m_n;}

    void getData(T* data)const;

	DynMatrix operator+(const DynMatrix& other) const;
	const DynMatrix& operator+=(const DynMatrix& other);

	DynMatrix operator*(const T& scalar) const;
	const DynMatrix& operator*=(const T& scalar);

	const DynMatrix& operator=(const DynMatrix& other);

	bool operator<(const DynMatrix& other);

private:
	T* m_data;
	unsigned int m_n;
	unsigned int m_m;
};

template<typename T>
DynMatrix<T>::DynMatrix()
:
	m_data(0),
	m_n(0),
	m_m(0)
{
	
}

template<typename T>
DynMatrix<T>::DynMatrix(const DynMatrix& other)
:
	m_data((other.m_n*other.m_m) ? new T[other.m_n*other.m_m] : 0),
	m_n(other.m_n),
	m_m(other.m_m)
{
	if (m_data)
	{
		for (unsigned int i = 0; i < m_m*m_n; i++)
		{
			m_data[i] = other.m_data[i];
		}
	}
}

template<typename T>
DynMatrix<T>::DynMatrix(unsigned int n,unsigned int m,T* data)
:
	m_data((n*m) ? new T[n*m] : 0),
	m_n(n),
	m_m(m)
{
	if (data)
	{
		for (unsigned int i = 0; i < m*n; i++)
		{
			m_data[i] = data[i];
		}
	}
}

template<typename T>
DynMatrix<T>::~DynMatrix()
{
	if(m_data)
		delete[] m_data;
}

template<typename T>
void DynMatrix<T>::getData(T* data)const
{
	for (unsigned int i = 0; i < m_m*m_n; i++)
		data[i] = m_data[i];
}

template<typename T>
DynMatrix<T> DynMatrix<T>::operator+(const DynMatrix& other) const
{
	DynMatrix<T> result = *this;
	result += other;
	return result;
}

template<typename T>
const DynMatrix<T>& DynMatrix<T>::operator+=(const DynMatrix& other)
{
	assert(other.m_n == m_n && other.m_m = m_m);

	for (unsigned int i = 0; i < m_n*m_m; i++)
	{
		m_data[i] += other.m_data[i];
	}

	return *this;
}

template<typename T>
DynMatrix<T> DynMatrix<T>::operator*(const T& scalar) const
{
	DynMatrix<T> result = *this;
	result *= scalar;
	return result;	
}

template<typename T>
const DynMatrix<T>& DynMatrix<T>::operator*=(const T& scalar)
{
	for (unsigned int i = 0; i < m_n*m_m; i++)
	{
		m_data[i] *= scalar;
	}

	return *this;
}

template<typename T>
const DynMatrix<T>& DynMatrix<T>::operator=(const DynMatrix<T>& other)
{
	if (other.m_n != m_n || other.m_m != other.m_m)
	{
		if (m_data)
			delete[] m_data;

		m_n = other.m_n;
		m_m = other.m_m;

		m_data = new T[m_n*m_m];
	}
	
	if (m_data)
	{
		for (unsigned int i = 0; i < m_m*m_n; i++)
		{
			m_data[i] = other.m_data[i];
		}
	}

	return *this;
}

template<typename T>
bool DynMatrix<T>::operator<(const DynMatrix& other)
{
	assert(m_m == other.m_m && m_n == other.m_n);

	for (unsigned int i = 0; i < m_m*m_n; i++)
	{
		if (m_data[i] >= other.m_data[i]) return false;
	}

	return true;
}

#endif /* __DYNMATRIX */
