import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt



def shorten_categories(categories, cutoff):
    categorical_map = {}
    for i in range(len(categories)):
        if categories.values[i] >= cutoff:
            categorical_map[categories.index[i]] = categories.index[i]
        else:
            categorical_map[categories.index[i]] = 'other'
    return categorical_map

def clean_experience(x):
    if x == 'More than 50 years':
        return 50
    if x == 'Less than 1 year':
        return 0.5
    return float(x)


def clean_education(x):
    if 'Bachelor’s degree' in x:
        return 'Bachelor’s degree'
    if 'Master’s degree' in x:
        return 'Master’s degree'
    if 'Professional degree' in x or 'Other doctoral degree' in x:
        return 'Post grad'
    return 'Less than a Bachelors'

@st.cache
def load_data():
    survey_df = pd.read_csv(r"C:\Users\mokaba\Downloads\survey_results_public.csv")
    survey_df = survey_df[['Country','EdLevel','YearsCode','Employment','ConvertedCompYearly']]
    survey_df = survey_df.rename({'ConvertedCompYearly':'Salary'}, axis= 1)
    survey_df = survey_df[survey_df.notnull()]
    survey_df = survey_df.dropna()
    survey_df.isnull().sum()
    survey_df = survey_df[survey_df['Employment'] == 'Employed full-time']
    survey_df = survey_df.drop('Employment', axis =1)

    country_map = shorten_categories(survey_df.Country.value_counts(), 400)
    survey_df['Country'] = survey_df['Country'].map(country_map)
    survey_df.Country.value_counts()

    survey_df = survey_df[survey_df['Salary'] <= 250000]
    survey_df = survey_df[survey_df['Salary'] > 10000]
    survey_df = survey_df[survey_df['Country'] != 'other']
    survey_df['EdLevel']= survey_df['EdLevel'].apply(clean_education)
    survey_df['YearsCode'] = survey_df['YearsCode'].apply(clean_experience)

    return survey_df

survey_df = load_data()

def show_explore_page():
    st.title('Explore Software Engineer Salaries')
    st.write(
        """
        ### Stack overflow Developer Survey 2020
        """
        
    )

data = survey_df['Country'].value_counts()

fig1, ax1 = plt.subplots()
ax1.pie(data, labels = data.index, autopct=" %1.1f%%", shadow=True, startangle=90)
ax1.axis("equal")

st.write(
    """
    ### Number of Data from different Countries
    """
)
st.pyplot(fig1)

st.write(
    """
    ### Mean Salary Based on Country
    """
)
data = survey_df.groupby(['Country'])['Salary'].mean().sort_values(ascending= True)
st.bar_chart(data)